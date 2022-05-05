function getJobTitleFromID(jobID)
	if (tonumber(jobID)==1) then
		return "Taksi Şoförü"
	elseif  (tonumber(jobID)==2) then
		return "Otobüs Şoförü"
    elseif (tonumber(jobID)==3) then
		return "Çöp Şöförü"
	elseif (tonumber(jobID)==4) then
		return "Beton Taşımacılığı"		
	elseif (tonumber(jobID)==5) then
		return "Tamirci"
	elseif (tonumber(jobID)==6) then
		return "Tütün Nakliyesi"		
	elseif (tonumber(jobID)==7) then
		return "Tır Şoförü"		
	elseif (tonumber(jobID)==8) then
		return "Odunculuk"				
	elseif (tonumber(jobID)==9) then
		return "Dondurmacılık"			
	elseif (tonumber(jobID)==11) then
		return "Kamyon Şoförü"			
	elseif (tonumber(jobID)==0) then
		return "İşsiz"
	else
		return "İşsiz"
	end
end