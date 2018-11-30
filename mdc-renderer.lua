local export = {}

function export.remove_comments(input)
	return mw.ustring.gsub(input, '<!%-%-(.-)%-%->', '')
end

function export.tokenize_hiero(input)
	input = mw.ustring.gsub(input, ' ', '-')
	input = mw.ustring.gsub(input, '\n', '-')
	input = mw.ustring.gsub(input, '\r', '-')
	input = mw.ustring.gsub(input, '\t', '-')
	input = mw.ustring.gsub(input, '%-%-+', '-')
	local quadrats = {}
	local i = 1
	while true do
		j = string.find(input, '-', i, true)
		if j ~= nil then
			table.insert(quadrats, string.sub(input, i, j - 1))
			i = j + 1
		else
			table.insert(quadrats, string.sub(input, i))
			break
		end
	end
	return quadrats
end

function export.mdc_to_image(mdc, height_in)
	local height = height_in or '38'
	local mirrored = ''
	if string.sub(mdc, -1) == '\\' then
		mirrored = '|class=mw-mirrored'
		mdc = string.sub(mdc, 1, -2)
	end
	local image = '<span style="margin: 1px;">\[\[File:Abydos-Bold-hieroglyph-' .. mdc .. '.png|' .. mdc .. '|x' .. height .. 'px|link=' .. mirrored .. '\]\]</span>'
	return image
end

function export.render_quadrat(unrendered)
	if unrendered == '!' then
		rendered = '</tr></table><table class="mw-hiero-table"><tr>'
	elseif unrendered == '<' then
		rendered = '<td>' .. '<span style="margin: 1px;">\[\[File:Hiero Ca1.svg|&lt;|x46px|link=\]\]</span>' .. '</td><td><table class="mw-hiero-table"><tr><td class="mw-hiero-box" style="height:2px;"></td></tr><tr><td><table class="mw-hiero-table"><tr><td>'
	elseif unrendered == '>' then
		rendered = '</td></tr></table></td></tr><tr><td class="mw-hiero-box" style="height:2px;"></td></tr></table></td><td>' .. '<span style="margin: 1px;">\[\[File:Hiero Ca2.svg|&gt;|x46px|link=\]\]</span>' .. '</td>'
	else
		stack = string.find(unrendered, ':')
		if stack ~= nil then
			upper = export.mdc_to_image(string.sub(unrendered, 1, stack - 1), '19')
			lower = export.mdc_to_image(string.sub(unrendered, stack + 1), '19')
			rendered = '<td height="40">' .. upper .. '<br>' .. lower .. '</td>'
		else
			rendered = export.mdc_to_image(unrendered)
			rendered = '<td height="40">' .. rendered .. '</td>'
		end
	end
	return rendered
end

function export.hiero(frame)
	local output = {}
	local hieros = frame.args[1]
	hieros = export.remove_comments(hieros)
	local tokenized = export.tokenize_hiero(hieros)
	for k, v in ipairs(tokenized) do
		v = export.render_quadrat(v)
		table.insert(output, v)
	end
	return '<table class="mw-hiero-table mw-hiero-outer" style="display:inline-table;vertical-align:middle;" dir="ltr"><tr><td><table class="mw-hiero-table"><tr>' .. table.concat(output) .. '</tr></table></td></tr></table>'
end

return export