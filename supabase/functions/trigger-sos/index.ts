import { serve } from 'https:
import { createClient } from 'https:

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

interface SOSRequest {
  userId: string
  triggerSource: string
  location: { lat: number; lng: number; accuracy: number }
  triggerData?: any
  heartRate?: number
  detectedEmotion?: string
  stressLevel?: number
}

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    const supabase = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
    )

    const sosData: SOSRequest = await req.json()

    const severity = determineSeverity(sosData)

    const { data: sosEvent, error: sosError } = await supabase
      .from('sos_events')
      .insert({
        user_id: sosData.userId,
        trigger_source: sosData.triggerSource,
        trigger_data: sosData.triggerData || {},
        location: `POINT(${sosData.location.lng} ${sosData.location.lat})`,
        location_accuracy: sosData.location.accuracy,
        severity,
        heart_rate: sosData.heartRate,
        detected_emotion: sosData.detectedEmotion,
        stress_level: sosData.stressLevel,
      })
      .select()
      .single()

    if (sosError) throw sosError

    const { data: user } = await supabase
      .from('users')
      .select('*')
      .eq('id', sosData.userId)
      .single()

    const { data: contacts } = await supabase
      .from('trusted_contacts')
      .select('*')
      .eq('user_id', sosData.userId)
      .eq('is_emergency_contact', true)
      .order('priority')

    const { data: safeSpo} = await supabase.rpc('find_nearest_safe_spot', {
      user_location: `POINT(${sosData.location.lng} ${sosData.location.lat})`,
      categories: ['hospital', 'police_station', 'petrol_pump'],
      max_distance_meters: 5000,
    })

    const nearestSafeSpot = safeSpots?.[0]

    if (nearestSafeSpot) {
      await supabase
        .from('sos_events')
        .update({ safe_spot_id: nearestSafeSpot.id })
        .eq('id', sosEvent.id)
    }

    const notificationPromises = contacts?.map(async (contact: any) => {
      try {

        await Promise.all([
          sendSMS(contact.phone_number, createSOSMessage(user, sosEvent, sosData.location)),
          sendWhatsApp(contact.phone_number, createSOSMessage(user, sosEvent, sosData.location)),
          sendPushNotification(contact.id, {
            title: `🚨 EMERGENCY - ${user.name}`,
            body: `${user.name} triggered SOS. Tap to help!`,
            data: {
              sosEventId: sosEvent.id,
              location: sosData.location,
            },
          }),
        ])

        return { contactId: contact.id, status: 'sent' }
      } catch (error) {
        return { contactId: contact.id, status: 'failed', error: error.message }
      }
    }) || []

    const notificationResults = await Promise.allSettled(notificationPromises)

    await supabase
      .from('sos_events')
      .update({
        contacts_notified: notificationResults.map(r =>
          r.status === 'fulfilled' ? r.value : { status: 'failed' }
        ),
      })
      .eq('id', sosEvent.id)

    if (severity === 'critical' && nearestSafeSpot?.category === 'police_station') {
      await notifyPolice(user, sosEvent, sosData.location, nearestSafeSpot)

      await supabase
        .from('sos_events')
        .update({ police_notified: true, police_notified_at: new Date().toISOString() })
        .eq('id', sosEvent.id)
    }

    await supabase
      .from('sos_events')
      .update({ status: 'active' })
      .eq('id', sosEvent.id)

    return new Response(
      JSON.stringify({
        success: true,
        sosEventId: sosEvent.id,
        severity,
        contactsNotified: notificationResults.length,
        nearestSafeSpot,
        policeNotified: severity === 'critical',
      }),
      {
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        status: 200,
      }
    )
  } catch (error) {
    return new Response(
      JSON.stringify({ error: error.message }),
      {
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        status: 400,
      }
    )
  }
})

function determineSeverity(sosData: SOSRequest): string {

  if (sosData.triggerSource === 'fall') return 'critical'

  if (sosData.triggerSource === 'biometric_hr' && sosData.heartRate) {
    const baseline = 75
    const increase = (sosData.heartRate - baseline) / baseline
    if (increase > 0.6) return 'critical'
    if (increase > 0.4) return 'high'
  }

  if (sosData.triggerSource === 'voice') {
    const emotion = sosData.detectedEmotion?.toLowerCase()
    if (emotion === 'scream' || emotion === 'panic') return 'critical'
    if (emotion === 'fear' || emotion === 'distress') return 'high'
  }

  if (sosData.triggerSource === 'manual') return 'high'

  return 'medium'
}

function createSOSMessage(user: any, sosEvent: any, location: any): string {
  return `🚨 EMERGENCY SOS - ${user.name}

Triggered: ${new Date().toLocaleTimeString('en-IN')}
Severity: ${sosEvent.severity.toUpperCase()}

📍 Location:
${location.lat}, ${location.lng}

📲 Track live:
https:

⚠️ Please check on ${user.name} IMMEDIATELY!`
}

async function sendSMS(phoneNumber: string, message: string) {
  const twilioSid = Deno.env.get('TWILIO_ACCOUNT_SID')
  const twilioToken = Deno.env.get('TWILIO_AUTH_TOKEN')
  const twilioNumber = Deno.env.get('TWILIO_PHONE_NUMBER')

  const response = await fetch(
    `https:
    {
      method: 'POST',
      headers: {
        'Authorization': 'Basic ' + btoa(`${twilioSid}:${twilioToken}`),
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: new URLSearchParams({
        From: twilioNumber!,
        To: phoneNumber,
        Body: message,
      }),
    }
  )

  return response.json()
}

async function sendWhatsApp(phoneNumber: string, message: string) {
  const twilioSid = Deno.env.get('TWILIO_ACCOUNT_SID')
  const twilioToken = Deno.env.get('TWILIO_AUTH_TOKEN')
  const twilioWhatsAppNumber = Deno.env.get('TWILIO_WHATSAPP_NUMBER')

  const response = await fetch(
    `https:
    {
      method: 'POST',
      headers: {
        'Authorization': 'Basic ' + btoa(`${twilioSid}:${twilioToken}`),
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: new URLSearchParams({
        From: `whatsapp:${twilioWhatsAppNumber}`,
        To: `whatsapp:${phoneNumber}`,
        Body: message,
      }),
    }
  )

  return response.json()
}

async function sendPushNotification(userId: string, notification: any) {

  console.log('Push notification:', userId, notification)
}

async function notifyPolice(user: any, sosEvent: any, location: any, policeStation: any) {
  if (!policeStation.phone_number) return

  const message = `EMERGENCY ALERT - SakhiPath
Name: ${user.name}
Phone: ${user.phone_number}
Location: ${location.lat}, ${location.lng}
Time: ${new Date().toLocaleTimeString('en-IN')}
Severity: ${sosEvent.severity}
Track: https:

  await sendSMS(policeStation.phone_number, message)
}
