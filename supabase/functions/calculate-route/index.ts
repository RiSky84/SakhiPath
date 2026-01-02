import { serve } from 'https:
import { createClient } from 'https:

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

interface RouteRequest {
  start: { lat: number; lng: number }
  destination: { lat: number; lng: number }
  routeType: 'safest' | 'fastest' | 'balanced'
  userId: string
}

interface SafetyScore {
  overall: number
  lighting: number
  business: number
  crowd: number
  reports: number
  infrastructure: number
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

    const { start, destination, routeType, userId }: RouteRequest = await req.json()

    const googleMapsKey = Deno.env.get('GOOGLE_MAPS_API_KEY')
    const directionsUrl = `https:

    const mapsResponse = await fetch(directionsUrl)
    const mapsData = await mapsResponse.json()

    if (mapsData.status !== 'OK') {
      throw new Error(`Google Maps API error: ${mapsData.status}`)
    }

    const scoredRoutes = await Promise.all(
      mapsData.routes.map(async (route: any) => {
        const safetyScore = await calculateRouteSafetyScore(route, supabase)

        return {
          ...route,
          safetyScore,
          distance: route.legs[0].distance.value,
          duration: route.legs[0].duration.value,
        }
      })
    )

    let selectedRoute
    if (routeType === 'safest') {
      selectedRoute = scoredRoutes.sort((a, b) => b.safetyScore.overall - a.safetyScore.overall)[0]
    } else if (routeType === 'fastest') {
      selectedRoute = scoredRoutes.sort((a, b) => a.duration - b.duration)[0]
    } else {

      selectedRoute = scoredRoutes.sort((a, b) => {
        const scoreA = a.safetyScore.overall * 0.6 - (a.duration / 3600) * 0.4
        const scoreB = b.safetyScore.overall * 0.6 - (b.duration / 3600) * 0.4
        return scoreB - scoreA
      })[0]
    }

    await supabase.from('routes').insert({
      user_id: userId,
      start_location: `POINT(${start.lng} ${start.lat})`,
      start_address: selectedRoute.legs[0].start_address,
      end_location: `POINT(${destination.lng} ${destination.lat})`,
      end_address: selectedRoute.legs[0].end_address,
      route_path: encodePolyline(selectedRoute.overview_polyline.points),
      route_type: routeType,
      distance_meters: selectedRoute.distance,
      duration_seconds: selectedRoute.duration,
      safety_score: selectedRoute.safetyScore.overall,
    })

    return new Response(
      JSON.stringify({
        success: true,
        route: selectedRoute,
        alternatives: scoredRoutes.filter(r => r !== selectedRoute).slice(0, 2),
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

async function calculateRouteSafetyScore(route: any, supabase: any): Promise<SafetyScore> {

  const points = decodePolyline(route.overview_polyline.points)

  const samplePoints = sampleRoutePoints(points, 200)

  const { data: segments } = await supabase.rpc('get_nearby_road_segments', {
    route_points: samplePoints,
    radius_meters: 50,
  })

  if (!segments || segments.length === 0) {

    return {
      overall: 5.0,
      lighting: 5.0,
      business: 5.0,
      crowd: 5.0,
      reports: 5.0,
      infrastructure: 5.0,
    }
  }

  const totalLength = segments.reduce((sum: number, s: any) => sum + s.length_meters, 0)

  const avgLighting = segments.reduce((sum: number, s: any) =>
    sum + (s.streetlights_per_km * 2 > 10 ? 10 : s.streetlights_per_km * 2) * s.length_meters, 0
  ) / totalLength

  const avgBusiness = segments.reduce((sum: number, s: any) =>
    sum + Math.min(10, s.open_businesses_count) * s.length_meters, 0
  ) / totalLength

  const avgCrowd = segments.reduce((sum: number, s: any) =>
    sum + Math.min(10, s.avg_crowd_density * 10) * s.length_meters, 0
  ) / totalLength

  const avgReports = segments.reduce((sum: number, s: any) => {
    const total = s.safety_reports_positive + s.safety_reports_negative
    const score = total > 0 ? (s.safety_reports_positive / total) * 10 : 5
    return sum + score * s.length_meters
  }, 0) / totalLength

  const avgInfra = segments.reduce((sum: number, s: any) => {
    let score = 0
    score += s.cctv_cameras_count > 0 ? 3 : 0
    score += s.has_footpath ? 3 : 0
    score += s.road_width_meters > 6 ? 4 : 2
    return sum + score * s.length_meters
  }, 0) / totalLength

  const overall = (
    avgLighting * 0.30 +
    avgBusiness * 0.25 +
    avgCrowd * 0.25 +
    avgReports * 0.15 +
    avgInfra * 0.05
  )

  return {
    overall: Math.round(overall * 10) / 10,
    lighting: Math.round(avgLighting * 10) / 10,
    business: Math.round(avgBusiness * 10) / 10,
    crowd: Math.round(avgCrowd * 10) / 10,
    reports: Math.round(avgReports * 10) / 10,
    infrastructure: Math.round(avgInfra * 10) / 10,
  }
}

function decodePolyline(encoded: string): Array<[number, number]> {
  const points: Array<[number, number]> = []
  let index = 0
  let lat = 0
  let lng = 0

  while (index < encoded.length) {
    let b
    let shift = 0
    let result = 0
    do {
      b = encoded.charCodeAt(index++) - 63
      result |= (b & 0x1f) << shift
      shift += 5
    } while (b >= 0x20)
    const dlat = (result & 1) !== 0 ? ~(result >> 1) : result >> 1
    lat += dlat

    shift = 0
    result = 0
    do {
      b = encoded.charCodeAt(index++) - 63
      result |= (b & 0x1f) << shift
      shift += 5
    } while (b >= 0x20)
    const dlng = (result & 1) !== 0 ? ~(result >> 1) : result >> 1
    lng += dlng

    points.push([lat / 1e5, lng / 1e5])
  }

  return points
}

function sampleRoutePoints(points: Array<[number, number]>, intervalMeters: number): any[] {
  const sampled = []
  let distanceCovered = 0

  for (let i = 0; i < points.length - 1; i++) {
    const [lat1, lng1] = points[i]
    const [lat2, lng2] = points[i + 1]

    const segmentDistance = haversineDistance(lat1, lng1, lat2, lng2)

    if (distanceCovered + segmentDistance >= intervalMeters) {
      sampled.push(`POINT(${lng1} ${lat1})`)
      distanceCovered = 0
    } else {
      distanceCovered += segmentDistance
    }
  }

  return sampled
}

function haversineDistance(lat1: number, lng1: number, lat2: number, lng2: number): number {
  const R = 6371e3
  const φ1 = lat1 * Math.PI / 180
  const φ2 = lat2 * Math.PI / 180
  const Δφ = (lat2 - lat1) * Math.PI / 180
  const Δλ = (lng2 - lng1) * Math.PI / 180

  const a = Math.sin(Δφ / 2) * Math.sin(Δφ / 2) +
    Math.cos(φ1) * Math.cos(φ2) *
    Math.sin(Δλ / 2) * Math.sin(Δλ / 2)
  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))

  return R * c
}

function encodePolyline(encoded: string): string {

  return `LINESTRING(${decodePolyline(encoded).map(p => `${p[1]} ${p[0]}`).join(', ')})`
}
