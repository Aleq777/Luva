

[![Static badge](https://img.shields.io/badge/language-English-blue)](README.md)
[![Static badge](https://img.shields.io/badge/language-Polski-red)](README.pl-PL.md)\
:poland: Polski

<h6>Aktualna wersja: 0.0-beta-1.3.0</h6>

# Wstęp

## Lua
[Lua](https://www.lua.org/) to prosty, ale potężny język skryptowy używany często w wielu aplikacjach, grach i środowiskach. Jest rewelacyjna w przypadku prostych projektów i małych modów.
Jednak niektórzy z nas chcą tworzyć większe, skomplikowane i bezpieczne skrypty, które znacząco modyfikują treść: duże mody, zaawansowane skrypty itd.\
Dlatego stworzyłem ***Luvę***.

## O frameworku Luva
**__Luva__** to potężny framework dla Lua, który wprowadza:
- Wiele nowych zachowań języka
- Twarde typowanie (strict typing)
- Zaawansowane programowanie obiektowe (OOP)
- Kompatybilność wersji Lua (Lua 5.1 - 5.5)

Celem Luvy jest tworzenie złożonych projektów w prosty, czytelny, modyfikowalny, bezpieczny i ujednolicony sposób, przy czym nadal może działać na zwykłych plikach `.lua` bez translatorów ani kompilatorów.\
W 100% napisane w Lua.\
Nie użyto AI.\
Jestem po prostu kurwa architektem.

## Założenia

### 1. Bezpieczne programowanie
Typy, obiekty itp. są sprawdzane najszybciej jak to tylko możliwe. Luva będzie informować o wszystkich możliwie problematycznych błędach.

### 2. Wszechstronność
Luva została stworzona głównie z powodu gry [Teardown](), ale skoro Lua jest używana wszędzie, to Luva powinna działać na każdym środowisku.\
(sory Stormworkerzy, póki co framework nie jest dostosowany dla was, może kiedyś powstanie branch do tego)

### 3. Kompatybilność wsteczna Lua
Wersjonowanie Lua nie jest zgodne z [semantic versioning](https://semver.org/), przez co drobne przeskoki między wersjami usuwają funkcje i nie są kompatybilne ze sobą.\
Luva będzie próbować umożliwić kompatybilność nadpisując niektóre funkcje i blokując używania niektórych starych.

Przykłady:
- Lua 5.1 ma `pack` i `unpack`, ale nowsze wersje przeniosły je do `table.pack/unpack`. Luva jednolici je po prostu definiując `table.pack/unpack` w 5.1 i zaleca używania tego.
- Lua 5.1 ma `getfenv` i `setfenv`, które zostały usunięte w późniejszych wersjach. Luva zabrania używania tych funkcji.
- W późniejszych wersjach ujednolicono niektóre funkcje (`loadstring` i `load`, `gfind` i `gmatch` itd)

### 4. Funkcje jako słowa kluczowe
Np. [switch](), [typeof](), [class](), ...

Pozwalają na skrócenie kodu, wydzielenie niektórych ważnych funkcjonalności poza obiekty i zwiększenie czytelności.

### 5. Ujednolicenie skryptów
Projekty stworzone w Luva framework powinny być kompatybilne między sobą [Config.lua](./Luva/Config.lua) powinien mieć te same ustawienia).

## Wymagania
- Wersja **Lua**: 5.1 - najnowsza (sprawdź [**SECURITY.md**](./SECURITY.pl-PL.md) dla aktualnej kompatybilności)
- Środowisko: metatabele, funkcja `dofile`

> [!TIP]
> Zalecane jest rozszerzenie [LuaLS](https://marketplace.visualstudio.com/items?itemName=sumneko.lua) dla intelisense i podpowiedzi

# Tworzenie projektu
W skrócie: pobierz repozytorium, w środowisku ustaw `Program.lua` jako plik wejściowy
i pisz kod w `Main.lua`, a kolejne pliki i pakiety importuj w `Main.lua` (lub w `Program.lua`).

Dokładniej:
## Konfiguracja środowiska

### Visual Studio Code
> [!NOTE]
> Znajdziesz tu instrukcje tylko dla Visual Studio Code.
> Jeśli używasz innego programu i wiesz jak tam zaimplementować Luvę,
> możesz dodać poradnik dla [README](./README.pl-PL.md) lub [wiki]()
Niestety, w innych edytorach/IDE nie sprawdzałem projektu, więc musicie sami ogarnąć.

1. Sklonuj repozytorium
2. Zainstaluj [LuaLS](https://marketplace.visualstudio.com/items?itemName=sumneko.lua)
3. W ustawieniach rozszerzenia, wybierz:
  - Wersja Lua
  - Funkcja importowania
4. Ustaw w środowisku `Program.lua` jako punkt wejścia (np. w Teardown tam umieść funkcje główne, ustaw jako główny plik w konfiguracji bądź zmień nazwę pliku)

## Wiele plików

Możesz dodać swoje nowe pliki gdzie chcesz, a za pomocą `import` możesz zaimportować je.

## Dodawanie pakietów

Najlepiej dodawaj w folderze z nazwą pakietu (np. Tak jak Luva ma folder `Luva`).
Zaimportuj z projektu odpowiedni plik lub pliki.

## Debugowanie

Osobiście używam rozszerzenia do VSC [Lua debbuger]()

# Media
- [Dokumentacja]()
- Zgłoś błąd [tutaj]()
- [Discord]() ... niedługo
