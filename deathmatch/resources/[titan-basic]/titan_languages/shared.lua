languages = {
	"Ingilizce",
	"Rusya",
	"Almanya",
	"Fransa",
	"Hollanda",
	"Italya",
	"Ispanya",
}

flags = {
	"ingilizce",
	"rusya",
	"almanya",
	"fransa",
	"hollanda",
	"italya",
	"ispanya",
}


function getLanguageName(language)
	return languages[language] or 'English'
end

function getLanguageCount()
	return #languages
end

function getLanguageList()
	return languages
end
