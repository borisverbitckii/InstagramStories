# InstagramStories

Приложение, которое позволяет просматривать/сохранять/делиться историями из инстаграм 
без авторизации пользователя в свой аккаунт

## Возможности:
- Искать пользователей в Instagram
- Просматривать профиль пользователя соц.сети
- Просматривать актуальные истории пользователя
- Сохранять в галерею и делиться видео историями из инстаграм
- Добавлять пользователей в избранные
- Просматривать историю поиска пользователей

Ссылка на AppStore: https://apps.apple.com/ru/app/instastories/id1603591536

**PS.** Функции сохранения и возможность делиться историями отключены из-за нарушения авторских прав соц. сети.

#### Скриншоты
<img src="https://is3-ssl.mzstatic.com/image/thumb/PurpleSource126/v4/c3/10/2e/c3102e17-aa3c-7d39-3123-18578ef7d832/97f7abec-2a84-413f-abcc-8a6196fe7c72_Simulator_Screen_Shot_-_iPhone_13_Pro_Max_-_2022-01-06_at_16.15.42.png/1284x2778bb.png" width="200"> <img src="https://is5-ssl.mzstatic.com/image/thumb/PurpleSource116/v4/49/80/ed/4980ed6d-c2eb-ea95-e98b-fc7ff837c739/5d0dc62b-6fff-4714-b27c-2447adde1dfe_Simulator_Screen_Shot_-_iPhone_13_Pro_Max_-_2022-01-07_at_23.18.51.png/1284x2778bb.png" width="200">
<img src="https://is2-ssl.mzstatic.com/image/thumb/PurpleSource126/v4/97/ad/c7/97adc7fd-df0d-8fe7-152a-48b55ed12c09/bc0b25d5-9a3d-4433-9b1a-4c8da60ca2cd_Simulator_Screen_Shot_-_iPhone_13_Pro_Max_-_2022-01-07_at_23.21.46.png/1284x2778bb.png" width="200">

#### Видео демонстрация
http://www.youtube.com/watch?v=1pnN9d9tw0w

### Особенности:
- Приложение построено на основе CollectionView
- Сделан сustomActivityIndicator
- Сделан customTabBar, сворачивающийся при скролле
- Кастомный transition в tabBarController между вьюКонтроллерами
- Переключение между табами по свайпу
- Кеширование скачанных изображений
- Кеширование скачанных видео
- Анимации на базе UIView.animate и UIView.transition
- Добавлена кастом кнопка для свайпа вверх, появляется при определенном offset
- Вся верстка в коде

## Техническая часть
### Архитектура - MVP + C

### Технологии:
- UIKit
- URLSession
- GCD (очереди и группы)
- Realm (предикаты, primaryKey)
- UserDefaults
- Generics

### Паттерны:
- Coordinator
- UseCase
- Factory
- Builder
- Singleton
- Delegates

### Библиотеки:
- Realm (https://github.com/realm/realm-swift)
- Swiftagram (https://github.com/sbertix/Swiftagram)
- PinLayout (https://github.com/layoutBox/PinLayout)
- Lottie (https://github.com/airbnb/lottie-ios)
- Firebase (https://github.com/firebase/firebase-ios-sdk)

### Зависимости - SPM
