#!/bin/bash

#Colors
GREEN="\e[0;32m\033[1m"
END="\033[0m\e[0m"
RED="\e[0;31m\033[1m"
BLUE="\e[0;34m\033[1m"
YELLOW="\e[0;33m\033[1m"
PURPLE="\e[0;35m\033[1m"
TURQUOISE="\e[0;36m\033[1m"
GRAY="\e[0;37m\033[1m"

function ctrl_c(){
	echo -e "\n\n${RED}[!] Saliendo...${END}\n"
	tput cnorm; exit 1

}

#Ctrl+C
trap ctrl_c INT

function helpPanel(){
	echo -e "\n${PURPLE}[+]${END}${GRAY} Uso:${END}\n"
	echo -e "\t${BLUE}-m${END}${GRAY}  Colocar la cantidad de dinero con el que se desea jugar${END}"
	echo -e "\t${BLUE}-t${END}${GRAY}  Colocar la técnica a utilizar (Martingala o Inverselabrouchere)${END}"
	echo -e "\t${BLUE}-h${END}${GRAY}  Mostrar este panel de ayuda${END}\n"
}

function martingala(){
	echo -e "\n${PURPLE}[+]${END}${GRAY} Dinero actual:${END}${BLUE} \$$money${END}"
	echo -n -e "${PURPLE}[+]${END}${GRAY} ¿Cuánto dinero quieres apostar? (Coloca solo el número) -> ${END}" && read initial_bet
	echo -n -e "${PURPLE}[+]${END}${GRAY} ¿A qué quieres apostar continuamente? ¿Par o impar?	-> ${END}" && read par_impar
#	echo -e "\n${PURPLE}[+]${END}${GRAY} Vamos a jugar con la cantidad inicial de${END}${BLUE} \$$initial_bet${END}${GRAY} al${END}${BLUE} $par_impar${END}"

	if [[ -n ${initial_bet//[0-9]/} ]]; then
		echo -e "\n${RED}[!] Debes ingresar un número entero, inténtalo de nuevo"
		exit 1
	fi


	if [ "${par_impar,,}" = "par" ]; then
		echo ""
	elif [ "${par_impar,,}" = "impar" ]; then
		echo ""
	else
		echo -e "\n${RED}[!] Debes ingresar par o impar, inténtalo de nuevo"
                exit 1
	fi


	backup_bet=$initial_bet
	play_counter=1
	jugadas_malas="[ "
	max_money=0

	tput civis
	while true; do
		money="$(($money-$initial_bet))"
#		echo -e "\n${PURPLE}[+]${END}${GRAY} Has apostado${END}${BLUE} \$$initial_bet${END}${GRAY}, ahora tienes${END}${BLUE} \$$money${END}"
		random_number="$(($RANDOM % 37))"
#		echo -e "${PURPLE}[+]${END}${GRAY} Ha salido el número${END}${BLUE} $random_number${END}"

		if [ ! "$money" -lt 0 ]; then
#POR SI EL USUARIO ELIGE PAR

			if [ "${par_impar,,}" == "par" ]; then
				if [ "$(($random_number % 2))" -eq 0 ]; then
					if [ "$random_number" -eq 0 ]; then
#						echo -e "${PURPLE}[+]${END}${RED} Te tocó 0, perdiste, jaja re tonto${END}"
#						echo -e "${PURPLE}[+]${END}${GRAY} Ahora tenés${END}${BLUE} \$$money${END}"
						initial_bet="$(($initial_bet * 2))"
						jugadas_malas+="$random_number "
					else
#						echo -e "${PURPLE}[+]${END}${GREEN} El número es par, ganaste :D${END}"
						reward="$(($initial_bet * 2))"
#						echo -e "${PURPLE}[+]${END}${GRAY} Ganaste${END}${PURPLE} \$$reward${END}"
						money="$(($money+$reward))"
#						echo -e "${PURPLE}[+]${END}${GRAY} Ahora tenés${END}${BLUE} \$$money${END}"
						initial_bet=$backup_bet
						jugadas_malas="[ "
						if [ "$money" -gt "$max_money" ]; then
							max_money=$money
						fi
					fi
				else
#					echo -e "${PURPLE}[+]${END}${RED} El número es impar, perdiste buuuuuuuu${END}"
#					echo -e "${PURPLE}[+]${END}${GRAY} Ahora tenés${END}${BLUE} \$$money${END}"
					initial_bet="$(($initial_bet * 2))"
					jugadas_malas+="$random_number "
				fi
#POR SI EL USUARIO ELIGE IMPAR

			else
				if [ "$(($random_number % 2))" -eq 1 ]; then
#					echo -e "${PURPLE}[+]${END}${GREEN} El número es impar, ganaste :D${END}"
					reward="$(($initial_bet * 2))"
#					echo -e "${PURPLE}[+]${END}${GRAY} Ganaste${END}${BLUE} \$$reward${END}"
					money="$(($money+$reward))"
#					echo -e "${PURPLE}[+]${END}${GRAY} Ahora tenés${END}${BLUE} \$$money${END}"
					initial_bet=$backup_bet
					jugadas_malas="[ "
					if [ "$money" -gt "$max_money" ]; then
						max_money=$money
					fi
				else
#					echo -e "${PURPLE}[+]${END}${RED} El número es par, perdisteee${END}"
#					echo -e "${PURPLE}[+]${END}${GRAY} Ahora tenés${END}${BLUE} \$$money${END}"
					initial_bet="$(($initial_bet * 2))"
					jugadas_malas+="$random_number "

				fi

			fi
		else # No hay plata
			echo -e "\n${RED}[!] TE QUEDASTE SIN PLATA JAJAJAJA${END}\n"
			echo -e "${PURPLE}[+]${END}${GRAY} Jugaste un total de ${END}${BLUE}$(($play_counter-1))${END}${GRAY} veces${END}"
			echo -e "\n${PURPLE}[+]${END}${GRAY} A continuación se van a mostrar las jugadas malas consecutivas que hicieron que pierdas:${END}"
			echo -e "${BLUE}$jugadas_malas]${END}"
			echo -e "\n${PURPLE}[+]${END}${GRAY} La mayor cantidad de dinero que obtuviste fue:${END}${BLUE} \$$max_money${END}"
			tput cnorm; exit 0
		fi

		let play_counter+=1

	done
	tput cnorm
}

function inverselabrouchere(){
	echo -e "\n${PURPLE}[+]${END}${GRAY} Dinero actual:${END}${BLUE} \$$money${END}"
        echo -n -e "${PURPLE}[+]${END}${GRAY} ¿A qué quieres apostar continuamente? ¿Par o impar?	-> ${END}" && read par_impar
	if [ "${par_impar,,}" = "par" ]; then
                echo ""
        elif [ "${par_impar,,}" = "impar" ]; then
                echo ""
        else
                echo -e "\n${RED}[!] Debes ingresar par o impar, inténtalo de nuevo"
                exit 1
        fi

	declare -a my_sequence=(1 2 3 4)

#	echo -e "\n${PURPLE}[+]${END}${GRAY} Comenzamos con la secuencia${END}${BLUE} [${my_sequence[@]}]${END}"

	bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
	play_counter=1
        max_money=0
	bet_to_renew=$(($money + 50))

	tput civis
	while true; do
		random_number="$(($RANDOM % 37))"
		let money-=$bet
#		echo -e "${PURPLE}[+]${END}${GRAY} Invertimos${END}${BLUE} \$$bet${END}"
#		echo -e "${PURPLE}[+]${END}${GRAY} Ahora tenemos:${END}${BLUE} \$$money${END}"
#		echo -e "\n${PURPLE}[+]${END}${GRAY} Ha salido el número${END}${BLUE} $random_number${END}"


		if [ "$money" -gt 0 ]; then


			if [ "${par_impar,,}" == "par" ]; then

				if [ "$(($random_number % 2))" -eq 0 ]; then

					if [ "$random_number" -eq 0 ]; then
#						echo -e "${PURPLE}[+]${END}${RED} Sacaste 0, perdiste${END}"
#						echo -e "${PURPLE}[+]${END}${GRAY} Ahora tenemos:${END}${BLUE} \$$money${END}"

						unset my_sequence[0]
						unset my_sequence[-1] 2>/dev/null
						my_sequence=(${my_sequence[@]})

						if [ $money -lt $(($bet_to_renew-100)) ]; then
 #                                               	echo -e "${PURPLE}[+]${END}${GRAY} Hemos llegado a un mínimo crítico, reajustamos el tope${END}"
                                                	let bet_to_renew-=50
  #                                              	echo -e "${PURPLE}[+]${END}${GRAY} Nuevo límite establecido a${END}${BLUE} \$$bet_to_renew${END}"
                                       		fi

#						echo -e "${PURPLE}[+]${END}${GRAY} La nueva secuencia es${END}${BLUE} [${my_sequence[@]}]${END}"
						if [ "${#my_sequence[@]}" -ne 1 ] && [ "${#my_sequence[@]}" -ne 0 ]; then
							bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
						elif [ "${#my_sequence[@]}" -eq 1  ]; then
							bet=${my_sequence[0]}
						else
#							echo -e "${RED}[!] Perdimos la secuencia D:${END}\n"
							my_sequence=(1 2 3 4)
#							echo -e "${PURPLE}[+]${END}${GRAY} Reestablecemos la secuencia a${END}${BLUE} [${my_sequence[@]}]${END}"
							bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
						fi
					else
#						echo -e "${PURPLE}[+]${END}${GREEN} Sacaste par, ganasteee${END}"
						reward=$(($bet * 2))
						let money+=$reward
#						echo -e "${PURPLE}[+]${END}${GRAY} Ahora tenemos:${END}${BLUE} \$$money${END}"
						my_sequence+=($bet)
						my_sequence=(${my_sequence[@]})

						if [ $money -gt $bet_to_renew ]; then
							let bet_to_renew+=50
							my_sequence=(1 2 3 4)
#							echo -e "${PURPLE}[+]${END}${GRAY} Se ha superado el límite establecido, renovamos la secuencia la secuencia a${END}${BLUE} [${my_sequence[@]}]${END}"
#							echo -e "${PURPLE}[+]${END}${GRAY} Nuevo límite establecido a${END}${BLUE} \$$bet_to_renew${END}"
							bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
						fi


#						echo -e "${PURPLE}[+]${END}${GRAY} La nueva secuencia es${END}${BLUE} [${my_sequence[@]}]${END}"
						if [ "${#my_sequence[@]}" -ne 1 ] && [ "${#my_sequence[@]}" -ne 0 ]; then
							bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
						elif [ "${#my_sequence[@]}" -eq 1  ]; then
							bet=${my_sequence[0]}
						else
 #       	                                        echo -e "${RED}[!] Perdimos la secuencia D:${END}\n"
                	                                my_sequence=(1 2 3 4)
  #                      	                        echo -e "${PURPLE}[+]${END}${GRAY} Reestablecemos la secuencia a${END}${BLUE} [${my_sequence[@]}]${END}"
							bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
						fi
						if [ "$money" -gt "$max_money" ]; then
                                                	max_money=$money
                                        	fi
					fi
				else
#					echo -e "${PURPLE}[+]${END}${RED} Sacaste impar, perdiste L${END}"
#					echo -e "${PURPLE}[+]${END}${GRAY} Ahora tenemos:${END}${BLUE} \$$money${END}"

					unset my_sequence[0]
					unset my_sequence[-1] 2>/dev/null
					my_sequence=(${my_sequence[@]})

					if [ $money -lt $(($bet_to_renew-100)) ]; then
 #                                       	echo -e "${PURPLE}[+]${END}${GRAY} Hemos llegado a un mínimo crítico, reajustamos el tope${END}"
                                                let bet_to_renew-=50
  #                                              echo -e "${PURPLE}[+]${END}${GRAY} Nuevo límite establecido a${END}${BLUE} \$$bet_to_renew${END}"
                                        fi

#					echo -e "${PURPLE}[+]${END}${GRAY} La nueva secuencia es${END}${BLUE} [${my_sequence[@]}]${END}"
					if [ "${#my_sequence[@]}" -ne 1 ] && [ "${#my_sequence[@]}" -ne 0 ]; then
						bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
					elif [ "${#my_sequence[@]}" -eq 1  ]; then
						bet=${my_sequence[0]}
					else
 #       	                                echo -e "${RED}[!] Perdimos la secuencia D:${END}\n"
                	                        my_sequence=(1 2 3 4)
#						echo -e "${PURPLE}[+]${END}${GRAY} Reestablecemos la secuencia a${END}${BLUE} [${my_sequence[@]}]${END}"
						bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
					fi
				fi

			else
				if [ "$(($random_number % 2))" -eq 1 ]; then
#					echo -e "${PURPLE}[+]${END}${GREEN} Sacaste impar, ganasteee${END}"
					reward=$(($bet * 2))
					let money+=$reward
#					echo -e "${PURPLE}[+]${END}${GRAY} Ahora tenemos:${END}${BLUE} \$$money${END}"
					my_sequence+=($bet)
					my_sequence=(${my_sequence[@]})

					if [ $money -gt $bet_to_renew ]; then
						let bet_to_renew+=50
						my_sequence=(1 2 3 4)
#						echo -e "${PURPLE}[+]${END}${GRAY} Se ha superado el límite establecido, renovamos la secuencia la secuencia a${END}${BLUE} [${my_sequence[@]}]${END}"
#						echo -e "${PURPLE}[+]${END}${GRAY} Nuevo límite establecido a${END}${BLUE} \$$bet_to_renew${END}"
						bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
					fi

#					echo -e "${PURPLE}[+]${END}${GRAY} La nueva secuencia es${END}${BLUE} [${my_sequence[@]}]${END}"

					if [ "${#my_sequence[@]}" -ne 1 ] && [ "${#my_sequence[@]}" -ne 0 ]; then
						bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
					elif [ "${#my_sequence[@]}" -eq 1  ]; then
						bet=${my_sequence[0]}
					else
#						echo -e "${RED}[!] Perdimos la secuencia D:${END}\n"
						my_sequence=(1 2 3 4)
#						echo -e "${PURPLE}[+]${END}${GRAY} Reestablecemos la secuencia a${END}${BLUE} [${my_sequence[@]}]${END}"
						bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
					fi
					if [ "$money" -gt "$max_money" ]; then
						max_money=$money
					fi

				else

#					echo -e "${PURPLE}[+]${END}${RED} Sacaste par, perdiste L${END}"
#					echo -e "${PURPLE}[+]${END}${GRAY} Ahora tenemos:${END}${BLUE} \$$money${END}"

					unset my_sequence[0]
					unset my_sequence[-1] 2>/dev/null
					my_sequence=(${my_sequence[@]})

					if [ $money -lt $(($bet_to_renew-100)) ]; then
#						echo -e "${PURPLE}[+]${END}${GRAY} Hemos llegado a un mínimo crítico, reajustamos el tope${END}"
						let bet_to_renew-=50
#						echo -e "${PURPLE}[+]${END}${GRAY} Nuevo límite establecido a${END}${BLUE} \$$bet_to_renew${END}"
					fi

#					echo -e "${PURPLE}[+]${END}${GRAY} La nueva secuencia es${END}${BLUE} [${my_sequence[@]}]${END}"
					if [ "${#my_sequence[@]}" -ne 1 ] && [ "${#my_sequence[@]}" -ne 0 ]; then
						bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
					elif [ "${#my_sequence[@]}" -eq 1  ]; then
						bet=${my_sequence[0]}
					else
#						echo -e "${RED}[!] Perdimos la secuencia D:${END}\n"
						my_sequence=(1 2 3 4)
#						echo -e "${PURPLE}[+]${END}${GRAY} Reestablecemos la secuencia a${END}${BLUE} [${my_sequence[@]}]${END}"
						bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
					fi

				fi

			fi
		else

			echo -e "\n${RED}[!] Te quedaste sin dinero${END}\n"
			echo -e "${PURPLE}[+]${END}${GRAY} Jugaste un total de ${END}${BLUE}$(($play_counter-1))${END}${GRAY} veces${END}"
                        echo -e "\n${PURPLE}[+]${END}${GRAY} La mayor cantidad de dinero que obtuviste fue:${END}${BLUE} \$$max_money${END}"
			tput cnorm; exit 1
		fi

		let play_counter+=1
	done
	tput cnorm

}

while getopts "m:t:h" arg; do
	case $arg in
	m) money=$OPTARG;;
	t) technique=$OPTARG;;
	h);;
	esac
done

if [ "$money" ] && [ "$technique" ]; then
	if [[ -n ${money//[0-9]/} ]]; then
		echo -e "\n${RED}[!] Debes ingresar un número entero, inténtalo de nuevo"
		helpPanel
		exit 1
	fi
	if [ "${technique,,}" == "martingala" ]; then
		martingala
	elif [ "${technique,,}" == "inverselabrouchere" ]; then
		inverselabrouchere
	else
		echo -e "\n${RED}[!] Técnica no encontrada, inténtalo de nuevo${END}"
		helpPanel
	fi
else
	helpPanel
fi
