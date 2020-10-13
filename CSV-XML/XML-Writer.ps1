# https://www.powershellmagazine.com/2013/08/19/mastering-everyday-xml-tasks-in-powershell/

$Path = "C:\temp\CSV-XML\Aus-QLD-Houses.xml"

# get an XMLTextWriter to create the XML
$XmlWriter = New-Object System.XMl.XmlTextWriter($Path,$Null)
 
# choose a pretty formatting:
$xmlWriter.Formatting = 'Indented'
$xmlWriter.Indentation = 1
$XmlWriter.IndentChar = "`t"
 
# write the header
$xmlWriter.WriteStartDocument()
 
# set XSL statements
$xmlWriter.WriteProcessingInstruction("xml-stylesheet", "type='text/xsl' href='style.xsl'")
 
# create root element and add some attributes to it
$xmlWriter.WriteStartElement('AUS-Housing')
$XmlWriter.WriteAttributeString('state', 'QLD')
 
#import CSV
$objs = Import-Csv -Path "C:\temp\CSV-XML\homes.csv"

#loop through each row
$objs | ForEach-Object -Process {
    $xmlWriter.WriteStartElement('Suburb')
    $XmlWriter.WriteAttributeString('Name', $_.Suburb)
    # add related information:
    $xmlWriter.WriteElementString('Houses',$_.Houses)
    $xmlWriter.WriteElementString('Rooms',$_.Rooms)
    $xmlWriter.WriteElementString('Beds',$_.Beds)
    $xmlWriter.WriteElementString('Baths',$_.Baths)

    $xmlWriter.WriteEndElement()
}
$xmlWriter.WriteEndElement()
# finalize the document:
$xmlWriter.WriteEndDocument()
$xmlWriter.Flush()
$xmlWriter.Close()
notepad $path

#convertto-xml -InputObject $obj -As 'string' | Out-File -Width 80 "C:\temp\CSV-XML\Houses.xml"
