function hasSpaceForItem( ... )
	return call( getResourceFromName( "titan_items" ), "hasSpaceForItem", ... )
end

function hasItem( element, itemID, itemValue )
	return call( getResourceFromName( "titan_items" ), "hasItem", element, itemID, itemValue )
end

function giveItem( element, itemID, itemValue )
	return call( getResourceFromName( "titan_items" ), "giveItem", element, itemID, itemValue, false, true )
end

function takeItem( element, itemID, itemValue )
	return call( getResourceFromName( "titan_items" ), "takeItem", element, itemID, itemValue )
end
