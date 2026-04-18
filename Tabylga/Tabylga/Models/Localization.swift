import Foundation

struct AppStrings {
    // Splash
    let appName: String
    
    // Onboarding
    let skip: String
    let saalamTitle: String
    let saalamSubtitle: String
    let continueButton: String
    let transportTitle: String
    let transportSubtitle: String
    let durationTitle: String
    let durationSubtitle: String
    
    // Home
    let greeting: String
    let greetingSubtitle: String
    let nomadicCalendar: String
    let fullCycle: String
    let routesForged: String
    let seeAll: String
    let todayLore: String
    let loreTitle: String
    let loreContent: String
    
    // Calendar
    let celestial: String
    let season: String
    let astronomy: String
    let tradition: String
    let activity: String
    let calendarLegend: String
    let fullMoon: String
    let sacredRite: String
    let celestialEvent: String
    let wisdom: String
    let celestialEventLabel: String
    let seasonalActivity: String
    let nomadicWisdom: String
    
    // Trip
    let searchPlaceholder: String
    let nearestRouteBanner: String
    let selectedLocation: String
    let crowsDistance: String
    let details: String
    let buildRoute: String
    let transportMode: String
    let back: String
    let car: String
    let cycle: String
    let walk: String
    
    // Discovery
    let discovery: String
    let newHeritageSite: String
    let discoveryDesc: String
    let description: String
    let geolocation: String
    let photos: String
    let add: String
    let sendToKeepers: String
    let knowledgeReceived: String
    let verifySite: String
    
    // Route Detail
    let distance: String
    let time: String
    let waypoints: String
    let routeLegend: String
    let keyLocations: String
    let startTrip: String
    let allRoutes: String
}

enum Localization {
    static func strings(for language: AppViewModel.Language) -> AppStrings {
        switch language {
        case .english:
            return AppStrings(
                appName: "TABYLGA",
                skip: "Skip",
                saalamTitle: "Saalam.\nChoose your tongue.",
                saalamSubtitle: "Experience the nomads' path in the language that resonates closest to your soul.",
                continueButton: "Continue",
                transportTitle: "How will you\ntrace the path?",
                transportSubtitle: "From the silent stride of a wanderer to the roar of a modern caravan.",
                durationTitle: "How long has\nthe steppe you?",
                durationSubtitle: "Choose the rhythm of your journey. Time is but a shadow on the sundial.",
                greeting: "SALAMATSYZBY, AYBEK",
                greetingSubtitle: "The steppe is listening.",
                nomadicCalendar: "NOMADIC CALENDAR",
                fullCycle: "FULL CYCLE",
                routesForged: "ROUTES FORGED FOR YOU",
                seeAll: "See all",
                todayLore: "TODAY'S LORE",
                loreTitle: "The Milk of the Mother Deer",
                loreContent: "In Chyn Kuran the mares foal and the first kumys is poured. A bowl is placed first for the ancestors — then the herd drinks, then the riders. Only after the spirits are fed does the human mouth taste the new season.",
                celestial: "Celestial",
                season: "Season",
                astronomy: "ASTRONOMY",
                tradition: "TRADITION",
                activity: "ACTIVITY",
                calendarLegend: "CALENDAR LEGEND",
                fullMoon: "Full Moon",
                sacredRite: "Sacred Rite",
                celestialEvent: "Celestial",
                wisdom: "Wisdom",
                celestialEventLabel: "Celestial Event",
                seasonalActivity: "Seasonal Activity",
                nomadicWisdom: "Nomadic Wisdom",
                searchPlaceholder: "Search the steppe...",
                nearestRouteBanner: "Это самый близкий маршрут",
                selectedLocation: "SELECTED LOCATION",
                crowsDistance: "crow's distance",
                details: "Details",
                buildRoute: "Build Route",
                transportMode: "TRANSPORT MODE",
                back: "BACK",
                car: "Car",
                cycle: "Cycle",
                walk: "Walk",
                discovery: "DISCOVERY",
                newHeritageSite: "New Heritage Site",
                discoveryDesc: "Have you found an unexplored historical site? Describe it and share its coordinates with the Tabylga keepers.",
                description: "DESCRIPTION",
                geolocation: "GEOLOCATION / COORDINATES",
                photos: "PHOTOS",
                add: "Add",
                sendToKeepers: "Send to Keepers",
                knowledgeReceived: "Knowledge Received",
                verifySite: "The keepers will verify the site. Your discovery strengthens the Tabylga.",
                distance: "Distance",
                time: "Time",
                waypoints: "Waypoints",
                routeLegend: "ROUTE LEGEND",
                keyLocations: "KEY LOCATIONS",
                startTrip: "Start This Trip",
                allRoutes: "ALL ROUTES"
            )
        case .russian:
            return AppStrings(
                appName: "TABYLGA",
                skip: "Пропустить",
                saalamTitle: "Салам.\nВыбери свой язык.",
                saalamSubtitle: "Пройди путь кочевника на языке, который ближе твоему сердцу.",
                continueButton: "Продолжить",
                transportTitle: "Как ты будешь\nпрокладывать путь?",
                transportSubtitle: "От тихого шага странника до рева современного каравана.",
                durationTitle: "Как долго степь\nбудет твоей?",
                durationSubtitle: "Выбери ритм своего путешествия. Время — лишь тень на солнечных часах.",
                greeting: "САЛАМАТСЫЗБЫ, АЙБЕК",
                greetingSubtitle: "Степь слушает тебя.",
                nomadicCalendar: "КОЧЕВОЙ КАЛЕНДАРЬ",
                fullCycle: "ВЕСЬ ЦИКЛ",
                routesForged: "МАРШРУТЫ ДЛЯ ТЕБЯ",
                seeAll: "Все",
                todayLore: "ЛЕГЕНДА ДНЯ",
                loreTitle: "Молоко Матери-Оленихи",
                loreContent: "В Чын Куран кобылицы приносят жеребят и разливается первый кумыс. Первая чаша ставится для предков — затем пьет табун, затем наездники. Только после того, как духи накормлены, человеческий рот пробует новый сезон.",
                celestial: "Небесное",
                season: "Сезон",
                astronomy: "АСТРОНОМИЯ",
                tradition: "ТРАДИЦИЯ",
                activity: "ЗАНЯТИЕ",
                calendarLegend: "ЛЕГЕНДА КАЛЕНДАРЯ",
                fullMoon: "Полнолуние",
                sacredRite: "Ритуал",
                celestialEvent: "Событие",
                wisdom: "Мудрость",
                celestialEventLabel: "Небесное событие",
                seasonalActivity: "Сезонное занятие",
                nomadicWisdom: "Мудрость предков",
                searchPlaceholder: "Поиск в степи...",
                nearestRouteBanner: "Это самый близкий маршрут",
                selectedLocation: "ВЫБРАННОЕ МЕСТО",
                crowsDistance: "расстояние по прямой",
                details: "Детали",
                buildRoute: "Построить маршрут",
                transportMode: "ВИД ТРАНСПОРТА",
                back: "НАЗАД",
                car: "Машина",
                cycle: "Велик",
                walk: "Пешком",
                discovery: "ОТКРЫТИЕ",
                newHeritageSite: "Новое место наследия",
                discoveryDesc: "Нашли неисследованное историческое место? Опишите его и поделитесь координатами с хранителями Tabylga.",
                description: "ОПИСАНИЕ",
                geolocation: "ГЕОПОЗИЦИЯ / КООРДИНАТЫ",
                photos: "ФОТОГРАФИИ",
                add: "Добавить",
                sendToKeepers: "Отправить хранителям",
                knowledgeReceived: "Знания получены",
                verifySite: "Хранители проверят место. Ваше открытие укрепляет Tabylga.",
                distance: "Дистанция",
                time: "Время",
                waypoints: "Точки",
                routeLegend: "ЛЕГЕНДА МАРШРУТА",
                keyLocations: "КЛЮЧЕВЫЕ МЕСТА",
                startTrip: "Начать это путешествие",
                allRoutes: "ВСЕ МАРШРУТЫ"
            )
        case .kyrgyz:
            return AppStrings(
                appName: "TABYLGA",
                skip: "Өткөрүп жиберүү",
                saalamTitle: "Салам.\nТилиңди танда.",
                saalamSubtitle: "Көчмөндөрдүн жолун жүрөгүңө жакын тилде сез.",
                continueButton: "Улантуу",
                transportTitle: "Жолду кантип\nбасып өтөсүң?",
                transportSubtitle: "Сезгенүүчү жолоочунун кадамынан заманбап кербендин үнүнө чейин.",
                durationTitle: "Сизди талаа канча\nубакытка чакырат?",
                durationSubtitle: "Саякатыңыздын ыргагын тандаңыз. Убакыт — күн саатындагы көлөкө гана.",
                greeting: "САЛАМАТСЫЗБЫ, АЙБЕК",
                greetingSubtitle: "Талаа сени угуп жатат.",
                nomadicCalendar: "КӨЧМӨН КАЛЕНДАРЫ",
                fullCycle: "ТОЛУК ЦИКЛ",
                routesForged: "СИЗ ҮЧҮН МАРШРУТТАР",
                seeAll: "Баары",
                todayLore: "КҮНДҮН УЛАМЫШЫ",
                loreTitle: "Бугу Эненин Сүтү",
                loreContent: "Чын Куранда бээлер кулундап, биринчи кымыз куюлат. Биринчи чөйчөк ата-бабалар үчүн коюлат — андан кийин үйүр, андан кийин чабандестер ичишет. Арбактарга сый көрсөтүлгөндөн кийин гана адам баласы жаңы сезондун даамын татат.",
                celestial: "Асмандык",
                season: "Мезгил",
                astronomy: "АСТРОНОМИЯ",
                tradition: "САЛТ-САНАА",
                activity: "АРАКЕТ",
                calendarLegend: "КАЛЕНДАРЬ ЛЕГЕНДАСЫ",
                fullMoon: "Толгон ай",
                sacredRite: "Ыйык ырым",
                celestialEvent: "Асман окуясы",
                wisdom: "Акылмандык",
                celestialEventLabel: "Асман окуясы",
                seasonalActivity: "Мезгилдик аракет",
                nomadicWisdom: "Көчмөн акылмандыгы",
                searchPlaceholder: "Талаадан издөө...",
                nearestRouteBanner: "Бул эң жакын маршрут",
                selectedLocation: "ТАНДАЛГАН ЖЕР",
                crowsDistance: "түз аралык",
                details: "Толугураак",
                buildRoute: "Жол куруу",
                transportMode: "ТРАНСПОРТ ТҮРҮ",
                back: "АРТКА",
                car: "Унаа",
                cycle: "Велосипед",
                walk: "Жөө",
                discovery: "ТАБЫЛГА",
                newHeritageSite: "Жаңы мурас орду",
                discoveryDesc: "Изилденбеген тарыхый жай таптыңызбы? Аны сүрөттөп, координаттарын Tabylga сактоочулары менен бөлүшүңүз.",
                description: "СҮРӨТТӨМӨ",
                geolocation: "ГЕОЛОКАЦИЯ / КООРДИНАТТАР",
                photos: "СҮРӨТТӨР",
                add: "Кошуу",
                sendToKeepers: "Сактоочуларга жөнөтүү",
                knowledgeReceived: "Маалымат кабыл алынды",
                verifySite: "Сактоочулар жерди текшеришет. Сиздин табылгаңыз Tabylgaны бекемдейт.",
                distance: "Аралык",
                time: "Убакыт",
                waypoints: "Чекиттер",
                routeLegend: "МАРШРУТ ЛЕГЕНДАСЫ",
                keyLocations: "НЕГИЗГИ ЖЕРЛЕР",
                startTrip: "Саякатты баштоо",
                allRoutes: "БАРДЫК МАРШРУТТАР"
            )
        }
    }
}
