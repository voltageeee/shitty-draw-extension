local mat_white = Material('vgui/white')

function draw.HalfCircle(x, y, rad, col, prt, thickns)
    render.ClearStencil()
    render.SetStencilEnable(true)

    render.SetStencilWriteMask(1)
    render.SetStencilTestMask(1)
    render.SetStencilFailOperation(STENCILOPERATION_REPLACE)
    render.SetStencilPassOperation(STENCILOPERATION_ZERO)
    render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
    render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)
    render.SetStencilReferenceValue(1)

    render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
    render.SetStencilPassOperation(STENCILOPERATION_REPLACE)

    surface.SetDrawColor(0, 0, 0, 255)
    if prt == 1 then
        surface.DrawRect(x - rad, y - rad, 2 * rad, rad)
    elseif prt == 2 then
        surface.DrawRect(x - rad, y, 2 * rad, rad)
    elseif prt == 3 then
        surface.DrawRect(x - rad, y - rad, rad, 2 * rad)
    elseif prt == 4 then
        surface.DrawRect(x, y - rad, rad, 2 * rad)
    end

    for i = 0, thickns - 1 do
        surface.SetDrawColor(col.r, col.g, col.b, col.a)
        surface.DrawCircle(x, y, rad - i, col)
    end

    render.SetStencilEnable(false)
end

function draw.SimpleGradient(x, y, w, h, startColor, endColor, horizontal)
	draw.LinearGradient(x, y, w, h, { {offset = 0, color = startColor}, {offset = 1, color = endColor} }, horizontal)
end

function draw.LinearGradient(x, y, w, h, stops, horizontal)
	if #stops == 0 then
		return
	elseif #stops == 1 then
		surface.SetDrawColor(stops[1].color)
		surface.DrawRect(x, y, w, h)
		return
	end

	table.SortByMember(stops, "offset", true)

	render.SetMaterial(mat_white)
	mesh.Begin(MATERIAL_QUADS, #stops - 1)
	for i = 1, #stops - 1 do
		local offset1 = math.Clamp(stops[i].offset, 0, 1)
		local offset2 = math.Clamp(stops[i + 1].offset, 0, 1)
		if offset1 == offset2 then continue end

		local deltaX1, deltaY1, deltaX2, deltaY2

		local color1 = stops[i].color
		local color2 = stops[i + 1].color

		local r1, g1, b1, a1 = color1.r, color1.g, color1.b, color1.a
		local r2, g2, b2, a2
		local r3, g3, b3, a3 = color2.r, color2.g, color2.b, color2.a
		local r4, g4, b4, a4

		if horizontal then
			r2, g2, b2, a2 = r3, g3, b3, a3
			r4, g4, b4, a4 = r1, g1, b1, a1
			deltaX1 = offset1 * w
			deltaY1 = 0
			deltaX2 = offset2 * w
			deltaY2 = h
		else
			r2, g2, b2, a2 = r1, g1, b1, a1
			r4, g4, b4, a4 = r3, g3, b3, a3
			deltaX1 = 0
			deltaY1 = offset1 * h
			deltaX2 = w
			deltaY2 = offset2 * h
		end

		mesh.Color(r1, g1, b1, a1)
		mesh.Position(Vector(x + deltaX1, y + deltaY1))
		mesh.AdvanceVertex()

		mesh.Color(r2, g2, b2, a2)
		mesh.Position(Vector(x + deltaX2, y + deltaY1))
		mesh.AdvanceVertex()

		mesh.Color(r3, g3, b3, a3)
		mesh.Position(Vector(x + deltaX2, y + deltaY2))
		mesh.AdvanceVertex()

		mesh.Color(r4, g4, b4, a4)
		mesh.Position(Vector(x + deltaX1, y + deltaY2))
		mesh.AdvanceVertex()
	end
	mesh.End()
end

function draw.RadialGradient(x, y, radius, stops)
    if #stops == 0 then
        return
    elseif #stops == 1 then
        surface.SetDrawColor(stops[1].color)
        surface.DrawRect(x - radius, y - radius, radius * 2, radius * 2)
        return
    end

    table.SortByMember(stops, "offset", true)

    render.SetMaterial(mat_white)
    local prts = 100
    for i = 1, #stops - 1 do
        local offset1 = math.Clamp(stops[i].offset, 0, 1)
        local offset2 = math.Clamp(stops[i + 1].offset, 0, 1)
        if offset1 == offset2 then continue end

        local color1 = stops[i].color
        local color2 = stops[i + 1].color

        local r1, g1, b1, a1 = color1.r, color1.g, color1.b, color1.a
        local r2, g2, b2, a2 = color2.r, color2.g, color2.b, color2.a

        local rad = offset2 * radius

        for j = 0, prts - 1 do
            local ang1 = math.rad((j / prts) * 360)
            local ang2 = math.rad(((j + 1) / prts) * 360)

            mesh.Begin(MATERIAL_TRIANGLES, 4)

            mesh.Color(r1, g1, b1, a1)
            mesh.Position(Vector(x, y))
            mesh.AdvanceVertex()

            mesh.Color(r2, g2, b2, a2)
            mesh.Position(Vector(x + math.cos(ang1) * rad, y + math.sin(ang1) * rad))
            mesh.AdvanceVertex()

            mesh.Color(r2, g2, b2, a2)
            mesh.Position(Vector(x + math.cos(ang2) * rad, y + math.sin(ang2) * rad))
            mesh.AdvanceVertex()

            mesh.End()
        end
    end
end

function draw.SimpleRadialGradient(x, y, radius, startColor, endColor)
    draw.RadialGradient(x, y, radius, { {offset = 0, color = startColor}, {offset = 1, color = endColor} })
end

hook.Add("HUDPaint", "shittydrawextension_test", function()
    draw.HalfCircle(250, 375, 100, Color(0, 238, 247), 1, 10)
    draw.HalfCircle(750, 310, 100, Color(0, 238, 247), 2, 10)
    draw.HalfCircle(1000, 350, 100, Color(0, 238, 247), 3, 10)
    draw.HalfCircle(450, 350, 100, Color(0, 238, 247), 4, 10)
    draw.SimpleGradient(200, 500, 100, 100, Color(255,0,0), Color(0,255,13), true)
    draw.SimpleGradient(350, 500, 100, 100, Color(255,0,0), Color(25,0,255), false)
    draw.SimpleRadialGradient(550, 550, 65, Color(255, 0, 0), Color(255, 255, 0))
    draw.SimpleRadialGradient(700, 550, 65, Color(0, 255, 0), Color(0, 0, 255))
end)
