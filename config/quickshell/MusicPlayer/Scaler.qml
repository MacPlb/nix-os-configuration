import QtQuick
import QtQuick.Window

QtObject {
    id: root

    // Rozdzielczość referencyjna, pod którą oryginalnie projektowano widget (zazwyczaj 1920)
    property real referenceWidth: 1920.0

    // Aktualna szerokość ekranu (przekazywana z zewnątrz lub brana domyślnie z systemu)
    property real currentWidth: Screen.width

    // Obliczanie współczynnika skalowania
    property real ratio: currentWidth / referenceWidth

    // Główna funkcja skalująca 's', używana we wszystkich elementach widgetu
    function s(value) {
        return value * ratio;
    }

    // Dodatkowa funkcja do zaokrąglania przy skalowaniu czcionek (opcjonalna, ale przydatna)
    function font(value) {
        return Math.round(value * ratio);
    }
}
