local PLUGIN = PLUGIN

function GAMEMODE:LoadFonts()
	surface.CreateFont("ix3D2DFont", {
		font = ix.config.Get("font"),
		size = 128,
		extended = true,
		weight = 100
	})

	surface.CreateFont("ix3D2DMediumFont", {
		font = ix.config.Get("font"),
		size = 48,
		extended = true,
		weight = 100
	})

	surface.CreateFont("ix3D2DSmallFont", {
		font = ix.config.Get("font"),
		size = 24,
		extended = true,
		weight = 400
	})

	surface.CreateFont("ixTitleFont", {
		font = ix.config.Get("font"),
		size = ScreenScale(40),
		extended = true,
		weight = 100
	})

	surface.CreateFont("ixSubTitleFont", {
		font = ix.config.Get("font"),
		size = ScreenScale(14),
		extended = true,
		weight = 100
	})

	surface.CreateFont("ixSubTitle2Font", {
		font = ix.config.Get("font"),
		size = ScreenScale(24),
		extended = true,
		weight = 100
	})

	surface.CreateFont("ixMenuMiniFont", {
		font = ix.config.Get("font"),
		size = math.max(ScreenScale(4), 18),
		weight = 300,
	})

	surface.CreateFont("ixMenuButtonFont", {
		font = ix.config.Get("font"),
		size = ScreenScale(14),
		antialias = true,
	})

	surface.CreateFont("ixMenuButtonFontSmall", {
		font = ix.config.Get("font"),
		size = ScreenScale(10),
		antialias = true,
	})

	surface.CreateFont("ixMenuButtonFontThick", {
		font = ix.config.Get("font"),
		size = ScreenScale(14),
		antialias = true,
	})

	surface.CreateFont("ixMenuButtonLabelFont", {
		font = ix.config.Get("font"),
		size = 28,
		antialias = true,
	})

	surface.CreateFont("ixMenuButtonHugeFont", {
		font = ix.config.Get("font"),
		size = ScreenScale(24),
		antialias = true,
	})

	surface.CreateFont("ixToolTipText", {
		font = ix.config.Get("font"),
		size = 20,
		extended = true,
		weight = 500
	})

	surface.CreateFont("ixMonoSmallFont", {
		font = "Consolas",
		size = 12,
		extended = true,
		weight = 800
	})

	surface.CreateFont("ixMonoMediumFont", {
		font = "Consolas",
		size = 22,
		extended = true,
		weight = 800
	})

	surface.CreateFont("ixBigFont", {
		font = ix.config.Get("font"),
		size = 36,
		extended = true,
		weight = 1000
	})

	surface.CreateFont("ixMediumFont", {
		font = ix.config.Get("font"),
		size = 25,
		extended = true,
		weight = 1000
	})

	surface.CreateFont("ixMedium2Font", {
		font = ix.config.Get("font"),
		size = 30,
		extended = true,
		weight = 1000
	})

	surface.CreateFont("ixNoticeFont", {
		font = ix.config.Get("font"),
		size = math.max(ScreenScale(8), 18),
		weight = 100,
		extended = true,
		antialias = true
	})

	surface.CreateFont("ixMediumLightFont", {
		font = ix.config.Get("font"),
		size = 25,
		extended = true,
		weight = 200
	})

	surface.CreateFont("ixMediumLightBlurFont", {
		font = ix.config.Get("font"),
		size = 25,
		extended = true,
		weight = 200,
		blursize = 4
	})

	surface.CreateFont("ixGenericFont", {
		font = ix.config.Get("font"),
		size = 20,
		extended = true,
		weight = 1000
	})

	surface.CreateFont("ixChatFont", {
		font = ix.config.Get("font"),
		size = math.max(ScreenScale(7), 17) * ix.option.Get("chatFontScale", 1),
		extended = true,
		weight = 600,
		antialias = true
	})

	surface.CreateFont("ixChatFontItalics", {
		font = ix.config.Get("font"),
		size = math.max(ScreenScale(7), 17) * ix.option.Get("chatFontScale", 1),
		extended = true,
		weight = 600,
		antialias = true,
		italic = true
	})

	surface.CreateFont("ixChatWhisperFont", {
		font = ix.config.Get("font"),
		size = math.max(ScreenScale(7), 17) * ix.option.Get("chatFontScale", 1) - ScreenScale(1),
		extended = true,
		weight = 600,
		antialias = true
	})

	surface.CreateFont("ixChatYellFont", {
		font = ix.config.Get("font"),
		size = math.max(ScreenScale(7), 17) * ix.option.Get("chatFontScale", 1) + ScreenScale(1),
		extended = true,
		weight = 600,
		antialias = true
	})

	surface.CreateFont("ixSmallTitleFont", {
		font = ix.config.Get("genericFont"),
		size = math.max(ScreenScale(12), 24),
		extended = true,
		weight = 100
	})

	surface.CreateFont("ixMinimalTitleFont", {
		font = "Roboto",
		size = math.max(ScreenScale(8), 22),
		extended = true,
		weight = 800
	})

	surface.CreateFont("ixSmallFont", {
		font = ix.config.Get("font"),
		size = math.max(ScreenScale(6), 17),
		extended = true,
		weight = 500
	})

	surface.CreateFont("ixSmallLightFont", {
		font = ix.config.Get("font"),
		size = math.max(ScreenScale(6), 17),
		extended = true,
		weight = 200
	})

	surface.CreateFont("ixTinyFont", {
		font = ix.config.Get("font"),
		size = math.max(ScreenScale(4), 14),
		extended = true,
		weight = 500
	})

	surface.CreateFont("ixItemDescFont", {
		font = ix.config.Get("font"),
		size = math.max(ScreenScale(6), 17),
		extended = true,
		shadow = true,
		weight = 500
	})

	surface.CreateFont("ixSmallBoldFont", {
		font = ix.config.Get("font"),
		size = math.max(ScreenScale(8), 20),
		extended = true,
		weight = 800
	})

	surface.CreateFont("ixItemBoldFont", {
		font = ix.config.Get("font"),
		shadow = true,
		size = math.max(ScreenScale(8), 20),
		extended = true,
		weight = 800
	})
    
	surface.CreateFont("ixIntroTitleFont", {
		font = ix.config.Get("genericFont"),
		size = math.min(ScreenScale(128), 128),
		extended = true,
		weight = 100
	})

	surface.CreateFont("ixIntroTitleBlurFont", {
		font = ix.config.Get("genericFont"),
		size = math.min(ScreenScale(128), 128),
		extended = true,
		weight = 100,
		blursize = 4
	})

	surface.CreateFont("ixIntroSubtitleFont", {
		font = ix.config.Get("genericFont"),
		size = ScreenScale(24),
		extended = true,
		weight = 100
	})

	surface.CreateFont("ixIntroSmallFont", {
		font = ix.config.Get("genericFont"),
		size = ScreenScale(14),
		extended = true,
		weight = 100
	})

	surface.CreateFont("ixIconsSmall", {
		font = "fontello",
		size = 22,
		extended = true,
		weight = 500
	})

	surface.CreateFont("ixSmallTitleIcons", {
		font = "fontello",
		size = math.max(ScreenScale(11), 23),
		extended = true,
		weight = 100
	})

	surface.CreateFont("ixIconsMedium", {
		font = "fontello",
		extended = true,
		size = 28,
		weight = 500
	})

	surface.CreateFont("ixIconsMenuButton", {
		font = "fontello",
		size = ScreenScale(14),
		extended = true,
		weight = 100
	})

	surface.CreateFont("ixIconsBig", {
		font = "fontello",
		extended = true,
		size = 48,
		weight = 500
	})
end