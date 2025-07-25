# Функция для выбора вариантов GeoSite
choice_geosite() {
    has_missing_geosite_bases=false
    has_updatable_geosite_bases=false

    for source in refilter v2fly zkeen; do
        var="update_${source}_geosite"
        msg_var="update_${source}_geosite_msg"
        
        if [ "$(eval echo \$$var)" = "false" ]; then
            has_missing_geosite_bases=true
        else
            eval "$msg_var=true"
            has_updatable_geosite_bases=true
        fi
    done

    while true; do
        install_refilter_geosite=false
        install_v2fly_geosite=false
        install_zkeen_geosite=false
        update_refilter_geosite=false
        update_v2fly_geosite=false
        update_zkeen_geosite=false
        choice_delete_geosite_refilter_select=false
        choice_delete_geosite_v2fly_select=false
        choice_delete_geosite_zkeen_select=false
        invalid_choice=false

        echo 
        echo -e "  Выберите номер или номера действий через пробел для ${yellow}GeoSite${reset}"
        echo 

        [ "$has_missing_geosite_bases" = true ] && echo "     1. Установить отсутствующие GeoSite" || echo -e "     1. ${italic}Все доступные GeoSite установлены${reset}"
        [ "$has_updatable_geosite_bases" = true ] && echo "     2. Обновить установленные GeoSite" || echo -e "     2. ${italic}Нет доступных GeoSite для обновления${reset}"

        [ "$update_refilter_geosite_msg" = "true" ] && refilter_choice="Обновить" || refilter_choice="Установить"
        [ "$update_v2fly_geosite_msg" = "true" ] && v2fly_choice="Обновить" || v2fly_choice="Установить"
        [ "$update_zkeen_geosite_msg" = "true" ] && zkeen_choice="Обновить" || zkeen_choice="Установить"

        echo "     3. $refilter_choice Re:filter"
        echo "     4. $v2fly_choice v2fly"
        echo "     5. $zkeen_choice Zkeen"
        echo 
        echo "     0. Пропустить"

        [ "$has_updatable_geosite_bases" = true ] && echo && echo "     6. Удалить установленные GeoSite"

        echo
        valid_input=true
        
        while true; do
            read -r -p "  Ваш выбор: " geosite_choices
            geosite_choices=$(echo "$geosite_choices" | sed 's/,/, /g')

            if echo "$geosite_choices" | grep -qE '^[0-6 ]+$'; then
                break
            else
                echo -e "  ${red}Некорректный ввод.${reset} Пожалуйста, выберите снова"
            fi
        done

        for choice in $geosite_choices; do
            case "$choice" in
                1)
                    if [ "$has_missing_geosite_bases" = "false" ]; then
                        echo -e "  Все GeoSite ${green}уже установлены${reset}"
                        if input_concordance_list "Вы хотите обновить их?"; then
                            update_refilter_geosite=true
                            update_v2fly_geosite=true
                            update_zkeen_geosite=true
                        else
                            invalid_choice=true
                        fi
                    else
                        [ "$update_refilter_geosite_msg" != "true" ] && install_refilter_geosite=true
                        [ "$update_v2fly_geosite_msg" != "true" ] && install_v2fly_geosite=true
                        [ "$update_zkeen_geosite_msg" != "true" ] && install_zkeen_geosite=true
                    fi
                    ;;
                2)
                    if [ "$has_updatable_geosite_bases" = "false" ]; then
                        echo -e "  ${red}Нет установленных GeoSite${reset} для обновления"
                        if input_concordance_list "Вы хотите установить их?"; then
                            install_refilter_geosite=true
                            install_v2fly_geosite=true
                            install_zkeen_geosite=true
                        else
                            invalid_choice=true
                        fi
                    else
                        [ "$update_refilter_geosite_msg" = "true" ] && update_refilter_geosite=true
                        [ "$update_v2fly_geosite_msg" = "true" ] && update_v2fly_geosite=true
                        [ "$update_zkeen_geosite_msg" = "true" ] && update_zkeen_geosite=true
                    fi
                    ;;
                3)
                    [ "$update_refilter_geosite_msg" != "true" ] && install_refilter_geosite=true || update_refilter_geosite=true
                    ;;
                4)
                    [ "$update_v2fly_geosite_msg" != "true" ] && install_v2fly_geosite=true || update_v2fly_geosite=true
                    ;;
                5)
                    [ "$update_zkeen_geosite_msg" != "true" ] && install_zkeen_geosite=true || update_zkeen_geosite=true
                    ;;
                0)
                    echo "  Выполнен пропуск установки / обновления GeoSite"
                    return
                    ;;
                6)
                    if [ "$has_updatable_geosite_bases" = "false" ]; then
                        echo -e "  ${red}Нет установленных GeoSite для удаления${reset}. Выберите другой пункт"
                        invalid_choice=true
                    else
                        choice_delete_geosite_refilter_select=true
                        choice_delete_geosite_v2fly_select=true
                        choice_delete_geosite_zkeen_select=true
                    fi
                    ;;
                *)
                    echo -e "  ${red}Некорректный ввод.${reset} Пожалуйста, выберите снова"
                    invalid_choice=true
                    ;;
            esac
        done

        [ "$invalid_choice" = true ] && continue

        install_list=
        update_list=
        delete_list=

        [ "$install_refilter_geosite" = true ] && install_list="$install_list ${yellow}Re:filter${reset},"
        [ "$install_v2fly_geosite" = true ] && install_list="$install_list ${yellow}v2fly${reset},"
        [ "$install_zkeen_geosite" = true ] && install_list="$install_list ${yellow}Zkeen${reset},"
        [ "$update_refilter_geosite" = true ] && update_list="$update_list ${yellow}Re:filter${reset},"
        [ "$update_v2fly_geosite" = true ] && update_list="$update_list ${yellow}v2fly${reset},"
        [ "$update_zkeen_geosite" = true ] && update_list="$update_list ${yellow}Zkeen${reset},"
        [ "$choice_delete_geosite_refilter_select" = true ] && delete_list="$delete_list ${yellow}Re:filter${reset},"
        [ "$choice_delete_geosite_v2fly_select" = true ] && delete_list="$delete_list ${yellow}v2fly${reset},"
        [ "$choice_delete_geosite_zkeen_select" = true ] && delete_list="$delete_list ${yellow}Zkeen${reset},"

        if [ -n "$install_list" ]; then
            echo -e "  Устанавливаются следующие GeoSite: ${install_list%,}"
        fi

        if [ -n "$update_list" ]; then
            echo -e "  Обновляются следующие GeoSite: ${update_list%,}"
        fi

        if [ -n "$delete_list" ]; then
            echo -e "  Удаляются следующие GeoSite: ${delete_list%,}"
        fi

        break
    done
}