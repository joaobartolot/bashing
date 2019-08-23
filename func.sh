# In this file is all my custom functions or commands

# Faster way to run python3 scripts
py () {
	python3 $1
}

function message {
	case $1 in
		-e)
			echo ""
			echo "*Error:"
			echo "	"$2
			echo ""
			;;
		-w)
			echo ""
			echo "*Warning:"
			echo "	"$2
			echo ""
			;;
		-m)
			echo ""
			echo $2
	esac
}

# Make a new virtual environment
mkenv () {
	if [ ! -d ~/.virtualenvs/ ]; then
		mkdir ~/.virtualenvs/
	fi

	if [ "$#" == 0 ]; then
		message -e "Please enter an argument"

	elif [ "$#" == 2 ]; then
		case $1 in
			-n)
				if [ $OSTYPE == 'msys' ]; then
					virtualenv ~/.virtualenvs/$2
					source ~/.virtualenvs/$2/Scripts/activate
				else
					virtualenv -p python3 ~/.virtualenvs/$2
					source ~/.virtualenvs/$2/bin/activate
				fi
				;;

			-d)
				if [ $OSTYPE == 'msys' ]; then
					virtualenv ~/.virtualenvs/$2
					source ~/.virtualenvs/$2/Scripts/activate
				else
					virtualenv -p python3 ~/.virtualenvs/$2
					source ~/.virtualenvs/$2/bin/activate
				fi
				pip install django
				django-admin startproject ~/Projects/$2
				cd ~/Projects/$2
				;;

		esac

	elif  [ "$#" == 1 ]; then
		if [ $OSTYPE == 'msys' ]; then
			virtualenv ~/.virtualenvs/$2
			source ~/.virtualenvs/$2/Scripts/activate
		else
			virtualenv -p python3 ~/.virtualenvs/$1
			source ~/.virtualenvs/$1/bin/activate
		fi

	fi
}

clone () {
	if [ $# == 1 ]; then
		git clone git@github.com:joaobartolot/$1.git

	elif [ $# == 2 ]; then
		case $1 in
			-d | --django-project)
				if [ ! -d ~/Projects ]; then
					mkdir ~/Projects
				fi

				if [ ! -d ~/Projects/$2 ]; then
					git clone git@github.com:joaobartolot/$2.git ~/Projects/$2

					cd ~/Projects/$2

					if [ "$VIRTUAL_ENV" == "" ]; then
						if [ ! -d ~/.virtualenvs/$2 ]; then
							mkenv -n $2

							if [ ! "$VIRTUAL_ENV" == "" ]; then
								pip install django

								if [ -f ./requirements.txt ]; then
									pip install -r requirements.txt
								fi

							else
								message -e "You are not in a virtual environment so we didn't install django"
								
							fi
							

							else
								message -e "This virtual environment already exists"
							fi

						else
							message -e "You are running a virtual environment. Please deactivate before create a new one"
						fi
					fi
					;;

		esac

	fi
}

workon () {
	# This function is for virtualenvs.

	if [ ! -d ~/.virtualenvs/ ]; then
		mkdir ~/.virtualenvs/
	fi

	if [ "$VIRTUAL_ENV" == "" ]; then
		if [ $# == 1 ]; then
			# Activating a virtual environment
			if [ $OSTYPE == 'msys' ]; then
				source ~/.virtualenvs/$1/Scripts/activate
			else
				source ~/.virtualenvs/$1/bin/activate
			fi

		elif [ $# == 2 ]; then
			# listing all virtual environments that exists in the virtualenvs folder
			case $1 in
				-l)
					ls ~/.virtualenvs/
					;;
				-m)
					message -m "Activating the virtualenv \"$2\""
					# Activating a virtual environment
					
					if [ $OSTYPE == 'msys' ]; then
						source ~/.virtualenvs/$2/Scripts/activate
					else
						source ~/.virtualenvs/$2/bin/activate
					fi
					
					if [ ! "$VIRTUAL_ENV" == "" ]; then
						message -m "Done!"
					fi
					;;

			esac
		fi

	else
		# If you are running a virtual environment it will display this message
		message -e "You are running a virtual environment. Please deactivate before create a new one"
	fi
}


runserver () {
		if [ $# == 0 ]; then
			if [ ! $VIRTUAL_ENV == "" ]; then
				if [ -f ./manage.py ]; then
					message -m "Running the server..."
					python manage.py runserver 0.0.0.0:8000
				else
					message -e "You need to be inside a django project folder to run this command"
				fi
			else
				message -e "Please run or create a virtual environment before running the server"
			fi

		# runserver --project project-name
		# runserver --project project-name --host ip-address --port port
		elif [ $# == 2 ]; then
			case $1 in
				-p | --project)
					cd ~/Projects/$2
					workon -m $2
					if [ ! $VIRTUAL_ENV == "" ]; then
						python manage.py runserver 0.0.0.0:8000
					fi
				;;
			esac

		elif [ $# == 6 ]; then
			case $1 in
				-p | --django-project)
					case $3 in
						-h | --host)
							case $5 in
								-po | --port)
									cd ~/Projects/$2
									workon -m $2
									if [ ! $VIRTUAL_ENV == "" ]; then
										message -m "Running the server..."
										python manage.py runserver $4:$6
									fi
									;;
							esac
							;;
					esac
					;;
			esac
									
		fi
}

livereload () {
		if [ $# == 0 ]; then
			if [ ! $VIRTUAL_ENV == "" ]; then
				if [ -f ./manage.py ]; then
					message -m "Running the liveserver..."
					python manage.py livereload
				else
					message -e "You need to be inside a django project folder to run this command"
				fi
			else
				message -e "Please run or create a virtual environment before running the server"
			fi

		# livereload --project project-name
		# livereload --project project-name --host ip-address --port port
		elif [ $# == 2 ]; then
			case $1 in
				-p | --project)
					cd ~/Projects/$2
					workon -m $2
					if [ ! $VIRTUAL_ENV == "" ]; then
						message -m "Running the liveserver..."
						python manage.py livereload
					fi
				;;
			esac
		fi
	
}

project () {
	if [ $# == 1 ]; then
		cd ~/Projects/$1

	elif [ $# == 2 ]; then
		case $1 in
			-a | --activate)
				cd ~/Projects/$2
				if [ "$VIRTUAL_ENV" == "" ]; then
					workon $2
				fi
				;;
		esac
	fi
}
