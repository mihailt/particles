# create canvas
canvas = document.createElement 'canvas'
ctx = canvas.getContext("2d")

# setting canvas width/heigth
width = canvas.width = document.width
height = canvas.height = document.height

# adding canvas to the document
document.body.appendChild canvas

#utils
random = (min, max=0) ->
	Math.floor(Math.random() * (max + 1 - min)) + min

config =
	fov: 250
	background: 'rgba(0,0,0,0.3)',
	color: [80, 140, 255],
	axis: 'z',
	step: 1,

gui = new dat.GUI();
gui.add(config, 'fov');
gui.add(config, 'step', 0, 10);
gui.addColor(config, 'background');
gui.addColor(config, 'color');
gui.add(config, 'axis', [ 'x', 'y', 'z' ] );




# app
particles = []

for i in [0..50000]
	particles.push({
		x: random(-400, 400),
		y: random(-400, 400),
		z: random(-400, 400)
	})

setPixel = (imageData, x, y)->
	x += width/2
	y += height/2
	if x < 0 || x > width || y < 0 || y > height
		return

	i = (( (y>>0) *width) + (x>>0)) * 4
	imageData.data[i] += config.color[0]
	imageData.data[i + 1] += config.color[1]
	imageData.data[i + 2] +=  config.color[2]

render = (dt)->
	ctx.fillStyle = config.background
	ctx.fillRect( 0, 0, width, height)

	imageData = ctx.getImageData(0,0, width, height)
	for p in particles
		scale = config.fov / (config.fov + p.z)
		setPixel( imageData, p.x * scale, p.y * scale)
		p[config.axis] -= config.step
		if p[config.axis] < -config.fov
			p[config.axis] += config.fov * 2
	ctx.putImageData( imageData ,0 ,0)


# app loop

lastUpdate = Date.now()
fps = 60

run = ()->
	now = Date.now()
	dt = now - lastUpdate
	if dt >= (1000 / fps)
		lastUpdate = now - dt % (1000 / fps)
		render(dt)
	requestAnimationFrame(run)


# run it
do run