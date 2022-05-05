function hasSpaceForItem( ... )
	return call( getResourceFromName( "titan_items" ), "hasSpaceForItem", ... )
end

function hasItem( element, itemID, itemValue )
	return call( getResourceFromName( "titan_items" ), "hasItem", element, itemID, itemValue )
end

function getItemName( itemID )
	return call( getResourceFromName( "titan_items" ), "getItemName", itemID )
end
