
local advlook_window = nil
local advlook_edit_window = nil
local advlook_editvalue_window = nil
local screen_x, screen_y = guiGetScreenSize( )

function toggleMouseDependingOnWindows( )
  showCursor( ( advlook_window or advlook_edit_window or advlook_editvalue_window ) and true or false )
  guiSetInputEnabled( advlook_editvalue_window and true or false )
end

--
-- Look window, i.e. if you look at someone else
--
function createLookWindow( name, description, attributes, editFunction )
  hideLookWindow( )
  
  advlook_window = guiCreateWindow( 298, 168, 600, 325, name, false )
  guiWindowSetSizable( advlook_window, false )
  
  -- Text with all info
  local label = guiCreateLabel( 8, 25, 700, 155, description, false, advlook_window )
  guiSetFont( label, "clear-normal" )
  guiLabelSetHorizontalAlign( label, "left", true )
  
  -- Grid that contains masks and badges
  local grid = guiCreateGridList( 11, 190, 690, 101, false, advlook_window )
  local column = guiGridListAddColumn( grid, "Üzerindeki kokular (yemek, uyuşturucu ve dahası..)", 0.95)
  for index, i in ipairs( attributes ) do
    local row = guiGridListAddRow( grid )
    guiGridListSetItemText( grid, row, column, i, false, false )
  end
  
  local x = ( 600 - 130 ) / 2
  if editFunction then
    x = x - 140 / 2
    
    local edit = guiCreateButton( x, 295, 130, 25, "Düzenle", false, advlook_window )
    addEventHandler( "onClientGUIClick", edit, editFunction, false )
    
    x = x + 140
  end
  local close = guiCreateButton( x, 295, 130, 25, "Kapat", false, advlook_window )
  addEventHandler( "onClientGUIClick", close, function( ) hideLookWindow( ) end, false )
  toggleMouseDependingOnWindows( )
  exports.titan_global:centerWindow(advlook_window)
end

function hideLookWindow( )
  if advlook_window then
    destroyElement( advlook_window )
    advlook_window = nil
    
    toggleMouseDependingOnWindows( )
  end
end

addEvent( "social:look", true )
addEventHandler( "social:look", getRootElement( ),
  function( age, race, gender, weight, height, description )
    local editButton = createLookWindow( getPlayerName( source ):gsub( "_", " " ),
      getPlayerName( source ):gsub( "_", " " )--[[:sub( 1, getPlayerName( source ):find( "_" ) )]] .. " isimli karakter " ..
      age .. " yaşında " .. ( race == 0 and "Siyahi" or race == 1 and "Beyaz" or "Asyalı" ) .. " " .. ( gender == 1 and "Bayan" or "Erkek" ) ..
      " toplam " .. weight .. "kilosu" ..
      " boy uzunluğu " .. height .. "cm.\n" ..
      "Saç Rengi: " .. description[1] .. "\n" ..
      "Saç Türü: " .. description[2] .. "\n" ..
      "Kişisel Özellikleri: " .. description[3] .. "\n" ..
      "Fiziksel Özellikleri: " .. description[4] .. "\n" ..
      "Giyim Tarzı: " .. description[5] .. "\n" ..
      "Aksesuarları: " .. description[6],
      description[7] or {},
      source == localPlayer and function( ) triggerEvent( "social:look:edit", localPlayer, age, race, gender, weight, height, description ) end )
  end
)

--
-- Grid of properties you can edit
--

function createEditablesWindow( )
  hideEditablesWindow( )
  
  advlook_edit_window = guiCreateWindow( screen_x - 191, 172, 181, 297, "Bilgilerini Değiştirme Arayüzü", false )
  guiWindowSetSizable( advlook_edit_window, false )
  
  -- Grid for all editable attributes
  local grid = guiCreateGridList( 9, 23, 163, 242, false, advlook_edit_window )
  local column = guiGridListAddColumn( grid, "Özellikler", 0.9 )
  
  for k, v in ipairs( editables ) do
    local row = guiGridListAddRow( grid )
    guiGridListSetItemText( grid, row, column, v.name, false, false )
    guiGridListSetItemData( grid, row, column, tostring( k ), false, false )
  end
  addEventHandler( "onClientGUIDoubleClick", grid, selectPropertyToEdit, false )
  
  local close = guiCreateButton( 12, 266, 157, 22, "Kapat", false, advlook_edit_window )
  addEventHandler( "onClientGUIClick", close, function( ) hideEditablesWindow( ) end, false )
    exports.titan_global:centerWindow(advlook_edit_window)

  toggleMouseDependingOnWindows( )
end

function hideEditablesWindow( )
  if advlook_edit_window then
    destroyElement( advlook_edit_window )
    advlook_edit_window = nil
    
    toggleMouseDependingOnWindows( )
  end
end

function setProperty( key, value )
  for k, v in ipairs( editables ) do
    if v.index == key then
      v.value = value
      return true
    end
  end
end

addEvent( "social:look:edit", true )
addEventHandler( "social:look:edit", localPlayer,
  function( age, race, gender, weight, height, description )
    for i = 1, 6 do
      setProperty( i, description[i] )
    end
    setProperty( "weight", weight )
    createEditablesWindow( )
  end
)

--
-- editing a single property
--
function selectPropertyToEdit( )
  local row, column = guiGridListGetSelectedItem( source )
  if row ~= -1 and column ~= -1 then
    local key = tonumber( guiGridListGetItemData( source, row, column ) )
    
    createEditValueWindow( key )
  end
end

function createEditValueWindow( key )
  hideEditValuesWindow( )
  
  local stuff = editables[ key ]
  
  advlook_editvalue_window = guiCreateWindow( 349, 300, 285, 105, "Edit your Looks - " .. stuff.name, false )
  guiWindowSetSizable( advlook_editvalue_window, false )
  
  guiCreateLabel(11, 26, 258, 16, "You're now editing your " .. stuff.name .. ".", false, advlook_editvalue_window)
  
  local edit = guiCreateEdit(12, 46, 250, 22, tostring( stuff.value ),false,advlook_editvalue_window)
  
  
  local save = guiCreateButton(15,72,123,21,"Save",false,advlook_editvalue_window)
  addEventHandler( "onClientGUIClick", save,
    function( )
      triggerServerEvent( "social:look:update", localPlayer, stuff.index, guiGetText( edit ) )
      stuff.value = guiGetText( edit )
      hideEditValuesWindow( )
    end,
    false
  )

  guiSetEnabled( save, stuff.verify( stuff.value ) or false )
  addEventHandler( "onClientGUIChanged", edit, function( ) guiSetEnabled( save, stuff.verify( guiGetText( source ) ) or false ) end, false )
  
  local cancel = guiCreateButton(142,72,123,21,"Cancel",false,advlook_editvalue_window)
  addEventHandler( "onClientGUIClick", cancel, function( ) hideEditValuesWindow( ) end, false )
  
  toggleMouseDependingOnWindows( )
end

function hideEditValuesWindow( )
  if advlook_editvalue_window then
    destroyElement( advlook_editvalue_window )
    advlook_editvalue_window = nil
    
    toggleMouseDependingOnWindows( )
  end
end
