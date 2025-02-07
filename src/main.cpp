#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include <QLocale>
#include <QTranslator>
#include "../include/FrameLessWindow.h"

int main(int argc, char *argv[]) {
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    QGuiApplication app(argc, argv);

    QTranslator translator;
    const QStringList uiLanguages = QLocale::system().uiLanguages();
    for (const QString &locale: uiLanguages) {
        const QString baseName = "music_player_" + QLocale(locale).name();
        if (translator.load(":/i18n/" + baseName)) {
            app.installTranslator(&translator);
            break;
        }
    }

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/main.qml"));

    /// 注册QML类型
    /// 1. 导入包名
    /// 2. 版本号
    /// 3. 小版本
    /// 4. QML端的组件名称
    qmlRegisterType<FrameLessWindow>("qc.window", 1, 0, "FrameLessWindow");
    QObject::connect(
            &engine, &QQmlApplicationEngine::objectCreated, &app,
            [url](QObject *obj, const QUrl &objUrl) {
                if (!obj && url == objUrl)
                    QCoreApplication::exit(-1);
            },
            Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
