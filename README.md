# Приложение Unsplash
## Тестовое задание для Redmadrobot
Клиент-серверное приложение, работающее с REST API с сервисом [Unsplash](https://unsplash.com).

**Язык**: Swift.

**Библиотека UI**: UIKit.

**Основные возможности**:

1. Отображение случайных фотографий и коллекций на стартовом экране.
2. Поиск по коллекциям и фотографиям.
3. Отображение данных в виде таблиц (коллекций) с подгрузкой данных (пагинацией).
4. Просмотр отдельной фотографии с возможностью масштабирования и загрузкой изображения в оригинальном размере.
5. Отображение детальной информации о фотографии.

**Что «под капотом»**:

1. Кеширование загруженных фотографий.
2. Пагинация на основе получаемых в ответе от сервера ссылок.
3. Обработка ошибок сервера.
4. Декодирование получаемых ссылок пагинации с помощью regex pattern.

**Особенности реализации**: Дополнительных библиотек, помимо нативных, не использовалось. Вся вёрстка выполнялась только с использованием XIB-файлов, без Storyboards. Такой выбор был сделан осознанно с целью расширения опыта и тренировки данного подхода.

### Реализованный функционал по экранам

**Стартовый экран**:

1. В верхней части экрана отображается одна случайная фотография. Имеется возможность открытия фотографии в отдельном окне просмотра.
2. Ниже отображается горизонтальная карусель из 10 фотографий, являющихся обложками случайных коллекций. Имеется возможность открытия представленных коллекций в отдельном окне просмотра. Также здесь расположена кнопка перехода к поиску по коллекциям.
3. В нижней части экрана отображается ещё одна горизонтальная карусель из 10 случайных фотографий, каждую из которых можно просмотреть в отдельном окне. Также здесь расположена кнопка перехода к поиску по фотографиям.

Пример стартового экрана:

![Start View](https://github.com/Blissfulman/UnsplashUIKit/blob/main/GIFs/StartView.gif)

**Экран поиска**:

1. Имеется текстовое поле для ввода поискового запроса.
2. Имеется переключатель сортировки результата поиска (сортировка реализуется сервером).
3. Кнопка старта поиска.

Экраны поиска по коллекциям и по фотографиям отличаются только заголовками. В случае пустого результата поиска отображается соответствующее всплывающее сообщение.

Пример экрана поиска:

![Search View](https://github.com/Blissfulman/UnsplashUIKit/blob/main/GIFs/SearchView.gif)

**Экран списка коллекций**:

1. В верхней части экрана показано общее число коллекций в отображаемом списке.
2. Список коллекций представлен в виде таблицы, в каждой строке которой есть до 4-х небольших изображений первых фотографий коллекции, а также приведена следующая информация: заголовок, общее количество фотографий, дата публикации и имя пользователя.
3. При выборе отдельной коллекции из списка осуществляется переход на экран со списком фотографий данной коллекции.
4. При прокрутке списка при необходимости данные автоматически подгружаются.

Пример экрана списка коллекций:

![Collection List View](https://github.com/Blissfulman/UnsplashUIKit/blob/main/GIFs/CollectionListView.gif)

**Экран списка фотографий**:

1. В верхней части экрана показано общее число фотографий в отображаемом списке, а также имеется переключатель количества столбцов списка (от 1 до 3).
2. При выборе отдельной фотографии осуществляется переход на экран просмотра данной фотографии.
3. При прокрутке списка при необходимости данные автоматически подгружаются.

Пример экрана списка фотографий:

![Photo List View](https://github.com/Blissfulman/UnsplashUIKit/blob/main/GIFs/PhotoListView.gif)

**Экран просмотра фотографии**:

1. В центре экрана отображается фотография, загруженная в крупном, но не максимальном разрешении. Имеется возможность изменения масштаба стандартным жестом масштабирования, а также двойным тапом.
2. В верхней части экрана имеется две кнопки. Кнопка "Open original" подгружает фотографию в максимальном разрешении. Кнопка "i" открывает экран с информацией о фотографии.
3. В нижней части экрана отображается количество лайков, просмотров и загрузок данной фотографии.

Пример экрана просмотра фотографии:

![Photo View](https://github.com/Blissfulman/UnsplashUIKit/blob/main/GIFs/PhotoView.gif)

**Экран информации о фотографии**:

1. Отображена следующая информация: имя пользователя, дата публикации, ширина и высота оригинала фотографии, локация (город), основное и альтернативное описаний фотографии. Некоторые из полей основаны на опциональных данных и могут быть пусты. Также рядом с именем пользователя есть небольшое изображение фотографии профиля.
2. В нижней части расположена кнопка "Back", возвращающая на предыдущий экран.

Данный экран модальный, может быть закрыт смахиванием вниз.

Пример экрана информации о фотографии:

![Photo Info View](https://github.com/Blissfulman/UnsplashUIKit/blob/main/GIFs/PhotoInfoView.gif)

### Дополнительная информация

Для доступа к API Unsplash требуется получить ключ доступа. Данный ключ (мой) добавлен в приложение как свойство перечисления `APIConstant`. Т.к. мой ключ выдан для приложения в демо-режиме, то имеется ограничение на 50 запросов к серверу в час, после чего доступ ограничивается до окончания часа.