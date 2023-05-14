extends Node2D
#Initializarea valorilor
var meteo
var cod
var des
var vreme
func _ready():
	$Network/HTTPRequest.request_completed.connect(_on_request_completed)
	$Network/HTTPRequest.request("https://api.open-meteo.com/v1/forecast?latitude=46.57&longitude=26.91&hourly=precipitation_probability,weathercode,is_day&daily=temperature_2m_max,temperature_2m_min&current_weather=true&forecast_days=1&timezone=auto")
	await $Network/HTTPRequest.request_completed
	codul_vremii()
	if(meteo["current_weather"]["is_day"]==1):
		$Text/StareaVremii.set("theme_override_colors/font_color",Color(0,0,0))
		$Text/Bacau.set("theme_override_colors/font_color",Color(0,0,0))
		$Text/Temperatura.set("theme_override_colors/font_color",Color(0,0,0))
		$Reincarcare.icon=ResourceLoader.load("res://Images/darkrefresh.png")
		match (vreme):
			0:
				$Day/Clear.show()
			1:
				$Day/Cloudy.show()
			2:
				$Day/Rainy.show()
			3:
				$Day/Snowy.show()
			4:
				$Day/Thunderstorm.show()
		$Reincarcare.show()
	else:
		$Text/StareaVremii.set("theme_override_colors/font_color",Color(255,255,255))
		$Text/Bacau.set("theme_override_colors/font_color",Color(255,255,255))
		$Text/Temperatura.set("theme_override_colors/font_color",Color(255,255,255))
		$Reincarcare.icon=ResourceLoader.load("res://Images/lightrefresh.png")
		match (vreme):
			0:
				$Night/Clear.show()
			1:
				$Night/Cloudy.show()
			2:
				$Night/Rainy.show()
			3:
				$Night/Snowy.show()
			4:
				$Night/Thunderstorm.show()
		$Reincarcare.show()
	$Text/Temperatura.text=str(meteo["current_weather"]["temperature"])+"°C"

func _on_request_completed(result, response_code, headers, body):
	meteo = JSON.parse_string(body.get_string_from_utf8())

func codul_vremii():
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

func _on_reincarcare_pressed():
	get_tree().reload_current_scene()
