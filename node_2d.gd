extends Node2D
var meteo
var temp="°C"
var cod
var des
var vreme
var a
func _ready():
	#Cerere de tip HTTP catre Open-Meteo pentru a obtine prognoza meteo
	$Network/HTTPRequest.request_completed.connect(_on_request_completed)
	$Network/HTTPRequest.request("https://api.open-meteo.com/v1/forecast?latitude=46.57&longitude=26.91&hourly=precipitation_probability,weathercode,is_day&daily=temperature_2m_max,temperature_2m_min&current_weather=true&forecast_days=1&timezone=auto")
	await get_tree().create_timer(4).timeout
	codul_vremii()
	if(meteo["current_weather"]["is_day"]==1):
		match (vreme):
			0:
				$Day.show()
				$Day/Clear.show()
			1:
				$Day.show()
				$Day/Cloudy.show()
			2:
				$Day.show()
				$Day/Rainy.show()
			3:
				$Day.show()
				$Day/Cloudy.show()
	else:
		match (vreme):
			0:
				$Night.show()
				$Night/Clear.show()
			1:
				$Night.show()
				$Night/Cloudy.show()
			2:
				$Night.show()
				$Night/Rainy.show()
			3:
				$Night.show()
				$Night/Cloudy.show()
	$Text/Temperatura.text=str(meteo["current_weather"]["temperature"])+temp
#Cand cererea HTTP este completa,copiaza toate datele primite in variabila meteo
#Variabila meteo este un dictionar,un fel de vector in C++
#Indexul este reprezentat de un cuvant,nu de un numar
func _on_request_completed(result, response_code, headers, body):
	meteo = JSON.parse_string(body.get_string_from_utf8())
#Fiecare tip de vreme are codul sau specific
#Aceasta functie va decoda codul vremii
#0-senin 1-innorat 2-plaoie 3-ninsoare
func codul_vremii():
	if(meteo):
		cod=int(meteo["current_weather"]["weathercode"])
		match (cod):
			0,1,2,3:
				des="In principal senin"
				vreme=0
			45,48:
				des="Ceata"
				vreme=1
			51,53,55,56,57:
				des="Burnita"
				vreme=1
			61,63,65,66,67:
				des="Ploaie usoara"
				vreme=2
			71,73,75,77:
				des="Ninsoare"
				vreme=3
			80,81,82:
				des="Averse de ploaie"
				vreme=3
		$Text/StareaVremii.text=des
