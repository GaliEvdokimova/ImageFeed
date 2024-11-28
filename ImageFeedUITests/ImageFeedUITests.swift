//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Galina evdokimova on 28.11.2024.
//

import XCTest

final class ImageFeedUITests: XCTestCase {

    private let app = XCUIApplication() // переменная приложения
    
    private let login = "" // Пожалуйста, введите ваш e-mail
    private let password = "f" // Пожалуйста, введите ваш пароль
    private let nameLabel = "" // Пожалуйста, введите ваши Имя и Фамилию
    private let loginNameLabel = "@" // Пожалуйста, введите ваше имя пользователя @...
    
    override func setUpWithError() throws {

        continueAfterFailure = false // настройка выполнения тестов, которая прекратит выполнения тестов, если в тесте что-то пошло не так
        
        app.launch() // запускаем приложение перед каждым тестом
    }

    func testAuth() throws {
        // тестируем сценарий авторизации
        
        // Нажать кнопку авторизации
            // Подождать, пока экран авторизации открывается и загружается
            // Ввести данные в форму
            // Нажать кнопку логина
            // Подождать, пока открывается экран ленты
        
        
        /*
              У приложения мы получаем список кнопок на экране и получаем нужную кнопку по тексту на ней
              Далее вызываем функцию tap() для нажатия на этот элемент
            */
        app.buttons["Authenticate"].tap()
        
        let webView = app.webViews["UnsplashWebView"]
        
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
        
        //найдёт поле для ввода логина
        let loginTextField = webView.descendants(matching: .textField).element
        
        sleep(5)
        
        loginTextField.tap()
        sleep(2)
        loginTextField.typeText(login) //введёт текст в поле ввода
        webView.swipeUp() //поможет скрыть клавиатуру после ввода текста
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
        
        passwordTextField.tap()
        sleep(2)
        passwordTextField.typeText(password)
        passwordTextField.swipeUp()
        
        webView.buttons["Login"].tap()
        
        let tablesQuery = app.tables //вернёт таблицы на экран
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0) //вернёт ячейку по индексу 0
        
        XCTAssertTrue(cell.waitForExistence(timeout: 5)) //подождёт появления ячейки на экране в течение 5 секунд
    }
    
    func testFeed() throws {
        // тестируем сценарий ленты
        
        // Подождать, пока открывается и загружается экран ленты
            // Сделать жест «смахивания» вверх по экрану для его скролла
            // Поставить лайк в ячейке верхней картинки
            // Отменить лайк в ячейке верхней картинки
            // Нажать на верхнюю ячейку
            // Подождать, пока картинка открывается на весь экран
            // Увеличить картинку
            // Уменьшить картинку
            // Вернуться на экран ленты
        
        let tablesQuery = app.tables //вернёт таблицы на экране
        
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0) //вернёт ячейку по индексу 0
        
        cell.swipeUp() //метод поможет осуществить скроллинг
        
        sleep(2)
        
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
        
        cellToLike.buttons["like button"].tap()
        sleep(2)
        cellToLike.buttons["like button"].tap()
        
        sleep(2)
        
        cellToLike.tap()
        
        sleep(2)
        
        let image = app.scrollViews.images.element(boundBy: 0) //вернёт первую картинку на scrollView
        
        // Zoom in
        image.pinch(withScale: 3, velocity: 1)
        
        // Zoom out
        image.pinch(withScale: 0.5, velocity: -1)
        
                let navBackButtonWhiteButton = app.buttons["nav back button white"]
        navBackButtonWhiteButton.tap()
    }
    
    func testProfile() throws {
        // тестируем сценарий профиля
        
        // Подождать, пока открывается и загружается экран ленты
           // Перейти на экран профиля
           // Проверить, что на нём отображаются ваши персональные данные
           // Нажать кнопку логаута
           // Проверить, что открылся экран авторизации
        
        sleep(3)
        
        app.tabBars.buttons.element(boundBy: 1).tap() //нажмёт таб с индексом 1 на TabBar
        
        XCTAssertTrue(app.staticTexts[nameLabel].exists)
        XCTAssertTrue(app.staticTexts[loginNameLabel].exists)
        
        app.buttons["Logout button"].tap()
        app.alerts["Пока, пока!"].scrollViews.otherElements.buttons["Да"].tap()
    }
}
