# 🎨 Dotfiles

Мои персональные конфигурации для Linux-окружения на базе **Hyprland** (Wayland) в стиле Catppuccin-Frappe.

## 📦 Установленные компоненты

| Компонент | Описание |
|-----------|----------|
| **Hyprland** | Динамический тайловый Wayland-композитор |
| **Waybar** | Панель состояния для Wayland |
| **Rofi** | Лаунчер приложений |
| **Foot** | Терминальный эмулятор |
| **Neovim** | Текстовый редактор |
| **Tmux** | Терминальный мультиплексор |
| **Yazi** | Консольный файловый менеджер |
| **Btop** | Монитор ресурсов |
| **Fastfetch** | Утилита для отображения информации о системе |
| **Bat** | Продвинутая замена `cat` с подсветкой синтаксиса |
| **Mpv** | Видеоплеер |
| **SwayNC** | Центр уведомлений |
| **Wlogout** | Меню выхода из сессии |

## 🚀 Установка

```bash
stow -t ~/.config config
```

## 🎨 Темы

Используется тема **Catppuccin Frappe**:
- Конфигурация Hyprland: `config/hypr/frappe.conf`
- Rofi: `config/rofi/catppuccin-frappe.rasi`
- Yazi: `Catppuccin Frappe.tmTheme`

## 📁 Структура

```
config/
├── bat/           # Настройки bat (cat с подсветкой)
├── btop/          # Конфигурация мониторинга ресурсов
├── fastfetch/     # Настройки fastfetch
├── foot/          # Терминал
├── hypr/          # Hyprland, hyprlock, hyprpaper, hypridle
├── mpv/           # Видеоплеер
├── nvim/          # Neovim (Lua + Lazy.nvim)
├── rofi/          # Лаунчер
├── swaync/        # Уведомления
├── theme/         # Обои
├── tmux/          # Tmux с плагинами
├── waybar/        # Панель состояния
├── wlogout/       # Меню выхода
└── yazi/          # Файловый менеджер
```

## 🛠 Требования

- Linux с Wayland
- Hyprland
- GNU Stow

---

> ⚠️ **Внимание**: Используйте на свой страх и риск. Некоторые конфигурации могут конфликтовать с вашим окружением.
