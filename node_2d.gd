extends Node2D
#Initializarea variabilelor
var meteo
var cod
var vreme
var long="26.916025"
var lat="46.568825"
var url="https://api.open-meteo.com/v1/forecast?latitude="+lat+"&longitude="+long+"&hourly=precipitation_probability,weathercode,is_day&daily=temperature_2m_max,temperature_2m_min&current_weather=true&forecast_days=1&timezone=auto"
#Rulare cand programul este incarcat
func _ready():
	#Cerere HTTP catre Open Meteo pentru a obtine prognoza meteo
	$Network/HTTPRequest.request_completed.connect(_on_request_completed)
	$Network/HTTPRequest.request(url)
	await $Network/HTTPRequest.request_completed
	codul_vremii()
	#Verifica daca este zi sau noapte
	#Schimba fundalul si culoarea textului in functie de codul vremii si ora
	if(meteo["current_weather"]["is_day"]==1):
		$Text/StareaVremii.set("theme_override_colors/font_color",Color(0,0,0))
		$Text/Bacau.set("theme_override_colors/font_color",Color(0,0,0))
		$Text/Temperatura.set("theme_override_colors/font_color",Color(0,0,0))
		$Reincarcare.icon=ResourceLoader.load("res://Images/darkrefresh.png")
		match (vreme):
			#Zi
			0:
				$Afisare/Fundal.texture=ResourceLoader.load("res://Images/Decent_Day.png")
				$Afisare/luminaSAUintuneric.texture=ResourceLoader.load("res://Images/Sunny.png")
			1:
				$Afisare/Fundal.texture=ResourceLoader.load("res://Images/Cloudy_Day.png")
			2:
				$Afisare/Fundal.texture=ResourceLoader.load("res://Images/Rainy_Day.png")
			3:
				$Afisare/Fundal.texture=ResourceLoader.load("res://Images/Snowy_Day.png")
			4:
				$Afisare/Fundal.texture=ResourceLoader.load("res://Images/Stormy_Day.png")
		$Reincarcare.show()
	else:
		$Text/StareaVremii.set("theme_override_colors/font_color",Color(255,255,255))
		$Text/Bacau.set("theme_override_colors/font_color",Color(255,255,255))
		$Text/Temperatura.set("theme_override_colors/font_color",Color(255,255,255))
		$Reincarcare.icon=ResourceLoader.load("res://Images/lightrefresh.png")
		match (vreme):
			#Noapte
			0:
				$Afisare/Fundal.texture=ResourceLoader.load("res://Images/Decent_Night.png")
				$Afisare/luminaSAUintuneric.texture=ResourceLoader.load("res://Images/Moon.png")
			1:
				$Afisare/Fundal.texture=ResourceLoader.load("res://Images/Cloudy_Night.png")
			2:
				$Afisare/Fundal.texture=ResourceLoader.load("res://Images/Rainy_Night.png")
			3:
				$Afisare/Fundal.texture=ResourceLoader.load("res://Images/Snowy_Night.png")
			4:
				$Afisare/Fundal.texture=ResourceLoader.load("res://Images/Stormy_Night.png")
		$Reincarcare.show()
	$Text/Temperatura.text=str(meteo["current_weather"]["temperature"])+"°C"

func _on_request_completed(result, response_code, headers, body):
	meteo = JSON.parse_string(body.get_string_from_utf8())

func codul_vremii():
	#Procesare cod vreme
	if(meteo):
		cod=int(meteo["current_weather"]["weathercode"])
		match (cod):
			0,1,2,3:
				$Text/StareaVremii.text="In principal senin"
				vreme=0
			45,48:
				$Text/StareaVremii.text="Ceata"
				vreme=1
			51,53,55,56,57:
				$Text/StareaVremii.text="Burnita"
				vreme=1
			61,63,65,66,67:
				$Text/StareaVremii.text="Ploaie usoara"
				vreme=2
			71,73,75,77,85,86:
				$Text/StareaVremii.text="Ninsoare"
				vreme=3
			80,81,82:
				$Text/StareaVremii.text="Averse de ploaie"
				vreme=2
			95,96,97:
				$Text/StareaVremii.text="Furtuna"
				vreme=4
