# Запрос на добавление ядра Mihomo
choice_add_mihomo() {
    while true; do
        echo
        echo
        echo -e "  ${green}Загрузить${reset} ядро ${yellow}Mihomo${reset}?"
        echo
        echo "     1. Да"
        echo "     0. Нет"
        echo

        valid_input=true
        add_mihomo=true

        while true; do
            read -r -p "  Ваш выбор: " update_choices
            update_choices=$(echo "$update_choices" | sed 's/,/, /g')

            if echo "$update_choices" | grep -qE '^[0-1]$'; then
                break
            else
                echo -e "  ${red}Некорректный ввод.${reset} Выберите один из предложенных вариантов"
            fi
        done

        for choice in $update_choices; do
            case "$choice" in
                1)
                    sleep 1
                    ;;
                0)
                    add_mihomo=false
                    ;;
                *)
                    echo -e "  ${red}Некорректный ввод${reset}"
                    valid_input=false
                    break
                    ;;
            esac
        done

        [ "$valid_input" = "true" ] && break

    done
}