# Ifnap

**Plan drives around your baby's nap schedule.**

Parents know the trick: a car ride is the most reliable way to get a baby to nap. Ifnap turns that into a plan — tell it when you're leaving, when you need to be back, and how long you want the baby to sleep in the car, and it builds drive courses that fit the nap window instead of fighting it.

> 아기를 재우러 나가는 드라이브, 감으로 돌지 말고 계획적으로 — 출발/복귀 시간과 아이 개월 수를 입력하면 낮잠 시간에 맞는 드라이브 코스를 제안합니다.

## How it works

1. **Set your window** — departure time, return time, child's age in months, and target drive minutes.
2. **Pick a destination** — choose from nearby place candidates.
3. **Compare courses** — themed course cards with total time, drive time, and expected return time.
4. **Review the route** — a stop-by-stop timeline with the full route drawn on a Mapbox map.
5. **Nap mode** — if the baby falls asleep, get alternative plans that keep the car moving instead of waking them up at the destination.

## Tech stack

| Layer | Choice |
| --- | --- |
| Framework | Flutter (Material 3) |
| State management | Riverpod (`NotifierProvider` around a single `PlanningSession`) |
| Maps & routing | Mapbox Maps Flutter — route line rendering, marker annotations, camera fitting |
| Location | Geolocator |
| Architecture | Feature-first modules (`features/<feature>/presentation`) with shared `models` and `providers` |

```
lib/
├── app/                  # App root & MaterialApp setup
├── core/theme/           # App theme
├── features/
│   ├── home/             # Nap-window & search condition input
│   ├── place_list/       # Destination candidates
│   ├── course_list/      # Generated courses with theme filtering
│   ├── course_detail/    # Timeline + route map
│   ├── map/              # Reusable Mapbox map view
│   └── sleep_mode/       # Alternatives for when the baby is asleep
├── models/               # Course, CourseStop, Place, PlanningSession, ...
├── providers/            # PlanningSession state
└── mock/                 # Mock course/place generators (current data source)
```

## Getting started

Requires a [Mapbox access token](https://docs.mapbox.com/help/getting-started/access-tokens/).

```bash
flutter pub get
flutter run --dart-define=MAPBOX_TOKEN=<your-mapbox-token>
```

## Status

Prototype (Mar–Apr 2026). The planning flow, course UI, route visualization, and nap mode are working end-to-end on top of **mock data** — courses and place candidates are generated locally, not fetched from a real API yet.

Planned next:

- Real place search and drive-time estimation via Mapbox APIs
- Nap-schedule presets by child age
- Saved courses and history
