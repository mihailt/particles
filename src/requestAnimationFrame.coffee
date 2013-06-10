# requestAnimationFrame polyfill
do ->
	w = window
	for vendor in ['ms', 'moz', 'webkit', 'o']
		break if w.requestAnimationFrame
		w.requestAnimationFrame = w["#{vendor}RequestAnimationFrame"]
		w.cancelAnimationFrame = (w["#{vendor}CancelAnimationFrame"] or
								  w["#{vendor}CancelRequestAnimationFrame"])

	if w.requestAnimationFrame
		return if w.cancelAnimationFrame
		browserRaf = w.requestAnimationFrame
		canceled = {}
		w.requestAnimationFrame = (callback) ->
			id = browserRaf (time) ->
				if id of canceled then delete canceled[id]
				else callback time
		w.cancelAnimationFrame = (id) -> canceled[id] = true
	else
		targetTime = 0
		w.requestAnimationFrame = (callback) ->
			targetTime = Math.max targetTime + 16, currentTime = +new Date
			w.setTimeout (-> callback +new Date), targetTime - currentTime

		w.cancelAnimationFrame = (id) -> clearTimeout id