local export = {}

function export.hieroforms(frame)
	local parent_args = frame:getParent().args
	local default_title = parent_args['head'] or mw.title.getCurrentTitle().text
	default_title = 'Alternative hieroglyphic writings of '
		.. require 'Module:script utilities'.tag_text(
			default_title, require 'Module:languages'.getByCode 'egy', nil, 'term', nil)
	local tabletitle = parent_args['title'] or default_title
	local text = '<div class="NavFrame" style="clear:both;display:inline-block;">\n<div class="NavHead" style="">' .. tabletitle .. '&nbsp;&nbsp;</div>\n<div class="NavContent">\n{| style="text-align:center;"'
	local i = 1
	while parent_args[i] do
		text = text .. '\n| style="background-color:#efefef"|<span style="margin:0px 6px;">' .. parent_args[i] .. '</span>'
		i = i + 1
	end
	local j = 1
	local no_read = true
	local since_last = 1
	local read = 'read1'
	while j < i do
		if parent_args[read] then
			if no_read then
				text = text .. '\n|-'
				no_read = false
			end
			while since_last > 0 do
				text = text .. '\n|'
				since_last = since_last - 1
			end
			local link = require 'Module:links'.full_link( {
				lang = require 'Module:languages'.getByCode 'egy', term = parent_args[read]
			}, 'term' )
			text = text .. 'style="background-color:#efefef"|' .. link
		end
		since_last = since_last + 1
		j = j + 1
		read = 'read' .. j
	end
	j = 1
	local no_date = true
	since_last = 1
	local date = 'date1'
	while j < i do
		if parent_args[date] then
			if no_date then
				text = text .. '\n|-'
				no_date = false
			end
			while since_last > 0 do
				text = text .. '\n|'
				since_last = since_last - 1
			end
			text = text .. 'style="background-color:#efefef"|' .. frame:expandTemplate{title = 'defdate', args = {parent_args[date]}}
		end
		since_last = since_last + 1
		j = j + 1
		date = 'date' .. j
	end
	j = 1
	local no_note = true
	since_last = 1
	local since_note = 1
	local note = 'note1'
	while j < i do
		if parent_args[note] then
			if no_note then
				text = text .. '\n|- style="font-size:70%"'
				no_note = false
			end
			while since_last > 0 do
				text = text .. '\n|'
				since_last = since_last - 1
			end
			text = text .. 'style="background-color:#efefef"|' .. parent_args[note]
		end
		since_last = since_last + 1
		j = j + 1
		note = 'note' .. j
	end
	text = text .. '\n|}</div></div>'
	return text
end

return export