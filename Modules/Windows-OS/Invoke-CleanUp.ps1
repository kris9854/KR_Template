# used to Create maps withín a folder and clean it up 

function Invoke-CleanUp {
    [CmdletBinding()]
    param (
        # Location to cleanup 
        [Parameter(Mandatory = $true)]
        [Validateset('3D Objects', 'Contacts', 'Desktop', 'Documents', 'Downloads', 'Favorites', 'Links', 'Music', 'OneDrive')]
        [string]
        $FolderName
    )
    
    begin {
        #Region Fileextensions
        $MusicFiles = [System.Collections.ArrayList]@(
            '.mp3',
            '.mp4',
            '.aif',
            '.cda',
            '.mid',
            'midi',
            'mpa',
            'ogg',
            '.wav',
            '.wma',
            'wpi'
        )

        $ExecutableFiles = [System.Collections.ArrayList]@(
            '.bin', #Binary disc image
            '.dmg', #macOS X disk image
            '.iso', #ISO disc image
            '.toast', #Toast disc image
            '.vcd' #Virtual CD 
        )
        $ScriptFiles = [System.Collections.ArrayList]@(
            '.apk', #Android package file
            '.bat', #Batch file
            '.bin', #Binary file
            '.cgi', #Perl script file
            '.pl', #Perl script file
            '.com', #MS-DOS command file
            '.exe', #Executable file
            '.gadget', #Windows gadget
            '.jar', #Java Archive file
            '.msi', #Windows installer package
            '.py', #Python file
            '.wsf', #Windows Script File
            '.ps1'  #PowerShell
            '.ps1m' #PowerShell module
        )
        $WebFiles = [System.Collections.ArrayList]@(
            '.asp', #Active Server Page file
            '.aspx', #Active Server Page file
            '.cer', #Internet security certificate
            '.cfm', #ColdFusion Markup file
            '.cgi', #Perl script file
            #'.pl', #Perl script file
            '.css', #Cascading Style Sheet file
            '.htm', #HTML file
            '.html', #HTML file
            '.js', #JavaScript file
            '.jsp', #Java Server Page file
            '.part', #Partially downloaded file
            '.php', #PHP file
            #'.py', #Python file
            '.rss', #RSS file
            '.xhtml' #XHTML file
        )
        $compressedfiles = [System.Collections.ArrayList]@(
            '.7z', #7-Zip compressed file
            '.arj', #ARJ compressed file
            '.deb', #Debian software package file
            '.pkg', #Package file
            '.rar', #RAR file
            '.rpm', #Red Hat Package Manager
            '.tar.gz', #Tarball compressed file
            '.z', #Z compressed file
            '.zip'      #Zip compressed file
        )
        $DatabaseFiles = [System.Collections.ArrayList]@(
            '.csv', #Comma separated value file
            '.dat', #Data file
            '.db'  #Database file
            '.dbf', #Database file
            '.log', #Log file
            '.mdb', #Microsoft Access database file
            '.sav', #Save file (e.g., game save file)
            '.sql', #SQL database file
            '.tar', #Linux / Unix tarball file archive
            '.xml' #XML file
        )
        $MailFiles = [System.Collections.ArrayList]@(
            '.email', #Outlook Express e-mail message file.
            '.eml', #E-mail message file from multiple e-mail clients, including Gmail.
            '.emlx', #Apple Mail e-mail file.
            '.msg', #Microsoft Outlook e-mail message file.
            '.oft', #Microsoft Outlook e-mail template file.
            '.ost', #Microsoft Outlook offline e-mail storage file.
            '.pst', #Microsoft Outlook e-mail storage file.
            '.vcf' #E-mail contact file.
        )
        $FontFiles = [System.Collections.ArrayList]@(
            '.fnt', #Windows font file
            '.fon', #Generic font file
            '.otf', #Open type font file
            '.ttf' #TrueType font file
        )
        $Pictures = [System.Collections.ArrayList]@(
            '.ai', #Adobe Illustrator file
            '.bmp', #Bitmap image
            '.gif', #GIF image
            '.ico', #Icon file
            '.jpeg', #JPEG image
            '.jpg', #JPEG image
            '.png', #PNG image
            '.ps', #PostScript file
            '.psd', #PSD image
            '.svg', #Scalable Vector Graphics file
            '.tif', #TIFF image 
            '.tiff' #TIFF image
        )

        $MovieFiles = [System.Collections.ArrayList]@(
            
        )

        $TextFiles = [System.Collections.ArrayList]@(
            
        )

        #Endregion Fileextensions
    }
    
    Process {
        
    }
    
    end {
        
    }
}