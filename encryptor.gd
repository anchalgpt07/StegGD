extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var file_handler
func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	file_handler=File.new()



func put_text(text,img):
	var textpool=text.to_ascii()
	var ntex=[]
	for x in textpool:
		if str(x).length()<3:
			ntex.append("0"+str(x))
		else:
			ntex.append(str(x))
	print(ntex)
	var imgarr=[]
	img.lock()

	for imgn in range(1,ntex.size()+1):
		var y=imgn/img.get_width()
		var x=imgn%img.get_width()
		var pix=img.get_pixel(x,y)
		var r=str(pix.r)
		r.pad_decimals(20)
		r=r.substr(0,5)+ntex[imgn-1]

		var rx="%x"%int(ntex[imgn-1])
		if rx.length()<2:
			rx="0"+rx

		var c=Color(0,pix.g,pix.b,pix.a)
		var cx=c.to_html()
		cx=cx.substr(0,2)+rx+cx.substr(4,4)
		print(cx)
		img.set_pixel(x,y,Color(cx))
	var p1=img.get_pixel(0,0)
	var c=Color(ntex.size()/100.0,p1.g,p1.b,p1.a)
	print(c)
	img.set_pixel(0,0,c)
	img.unlock()
	return img

func get_text(img):
	img.lock()
	var ar=[]
	var pix1=img.get_pixel(0,0)
	var si=round(pix1.r*100)
	print("pix1 is ", si)
	for imgn in range(1,si+1):
		var y=imgn/img.get_width()
		var x=imgn%img.get_width()
		var pix=img.get_pixel(x,y)
		var r=pix
		ar.append(r.r8)
		print(r.r8)
	img.unlock()
	print(ar)
	var pbar= PoolByteArray(ar)
	var ss=pbar.get_string_from_ascii()
	return ss

func _process(delta):
	var fpath=$filepath.text
	if !file_handler.file_exists(fpath):
		$hide.disabled=true
		$show.disabled=true
	else:
		$hide.disabled=false
		$show.disabled=false

func _on_hide_pressed():
	var img=Image.new()
	img.load($filepath.text)
	var message=$Message.text
	var newimg=put_text(message,img)
	$Save.set_filters(PoolStringArray(["*.png"]))
	$Save.popup_centered()
	yield($Save,"file_selected")

	newimg.save_png($Save.current_path)

func _on_show_pressed():
	var img=Image.new()
	img.load($filepath.text)
	$Message.text=get_text(img)
