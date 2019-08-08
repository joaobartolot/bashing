# In this file is all my custom functions or commands

# Faster way to run python3 scripts
py () {
	python3 $1
}

function message {
	case $1 in
		-e)
			echo ""
			echo "*ERROR*"
			echo "	"$2
			echo ""
			;;
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
				virtualenv -p python3 ~/.virtualenvs/$2
				source ~/.virtualenvs/$2/bin/activate
				;;

			-d)
				virtualenv -p python3 ~/.virtualenvs/$2
				source ~/.virtualenvs/$2
				pip install django
				;;

		esac

	elif  [ "$#" == 1 ]; then
		fullPath=

		virtualenv -p python3 ~/.virtualenvs/$1
		source ~/.virtualenvs/$1/bin/activate

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
							virtualenv -p python3 ~/.virtualenvs/$2
							source ~/.virtualenvs/$2/bin/activate

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
			source ~/.virtualenvs/$1/bin/activate

		elif [ $# == 2 ]; then
			# listing all virtual environments that exists in the virtualenvs folder
			case $1 in
				-l)
					ls ~/.virtualenvs/
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
					workon $2
					if [ ! $VIRTUAL_ENV == "" ]; then
						python manage.py runserver 0.0.0.0:8000
					fi
				;;
			esac
		fi
}
