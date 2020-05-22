
function Get-SysmonImageLoadEvent {
    <#
    .SYNOPSIS
        Get Sysmon Image Load events (EventId 7).
    .DESCRIPTION
        The image loaded event logs when a module is loaded in a specific process.
    .EXAMPLE
        PS C:\> Get-SysmonImageLoadEvent -ImageLoaded 'C:\Windows\System32\wshom.ocx'
        Find all processes that loaded the wshom.ocx image that provides functions like wsh.shell to scripts and scriptlets.
    .INPUTS
        System.IO.FileInfo
    .OUTPUTS
        Sysmon.EventRecord.ImageLoad
    .NOTES
        https://www.ultimatewindowssecurity.com/securitylog/encyclopedia/event.aspx?eventid=90007
    #>
    [CmdletBinding(DefaultParameterSetName = 'Local')]
    param (
        # Log name for where the events are stored.
        [Parameter(Mandatory = $false,
                   ValueFromPipelineByPropertyName = $true)]
        [string]
        $LogName = 'Microsoft-Windows-Sysmon/Operational',

        # Image that is loading other imagaes (Process full path in most cases).
        [Parameter(Mandatory = $false,
                   ValueFromPipelineByPropertyName = $true)]
        [string[]]
        $Image,
        
        # Image that was was loaded by a process.
        [Parameter(Mandatory = $false,
                   ValueFromPipelineByPropertyName = $true)]
        [string[]]
        $ImageLoaded,

        # If the image loaded as a driver is signed.
        [Parameter(Mandatory = $false,
                   ValueFromPipelineByPropertyName = $true)]
        [ValidateSet('true','false')]
        [string]
        $Signed,

        # If the signature on the driver is valid or not
        [Parameter(Mandatory = $false,
                   ValueFromPipelineByPropertyName = $true)]
        [ValidateSet('Valid','Invalid','Unavailable')]
        [string]
        $SignatureStatus,

        # Signature field referencing the signer of the driver.
        [Parameter(Mandatory = $false,
                   ValueFromPipelineByPropertyName = $true)]
        [string[]]
        $Signature,

        # File Version field of the file metadata for the image loaded.
        [Parameter(Mandatory = $false,
                   ValueFromPipelineByPropertyName = $true)]
        [string[]]
        $FileVersion,

        # Description field of the file metadata for the image loaded.
        [Parameter(Mandatory = $false,
                   ValueFromPipelineByPropertyName = $true)]
        [string[]]
        $Description,

        # Product field of the file metadata for the image loaded.
        [Parameter(Mandatory = $false,
                   ValueFromPipelineByPropertyName = $true)]
        [string[]]
        $Product,

        # Company field of the file metadata for the image loaded.
        [Parameter(Mandatory = $false,
                   ValueFromPipelineByPropertyName = $true)]
        [string[]]
        $Company,

        # Process Id for the process that loaded the image.
        [Parameter(Mandatory = $false,
                   ValueFromPipelineByPropertyName = $true)]
        [string[]]
        $ProcessId,

        # Process GUID for the process that loaded the image.
        [Parameter(Mandatory = $false,
                   ValueFromPipelineByPropertyName = $true)]
        [string[]]
        $ProcessGuid,

        # Hash for the image that was loaded.
        [Parameter(Mandatory = $false,
                   ValueFromPipelineByPropertyName = $true)]
        [string[]]
        $Hashes,

        # Rule Name for filter that generated the event.
        [Parameter(Mandatory = $false,
            ValueFromPipelineByPropertyName = $true)]
        [string[]]
        $RuleName,

        # Specifies the path to the event log files that this cmdlet get events from. Enter the paths to the log files in a comma-separated list, or use wildcard characters to create file path patterns. Function supports files with the .evtx file name extension. You can include events from different files and file types in the same command.
        [Parameter(Mandatory=$true,
                   Position=0,
                   ParameterSetName="file",
                   ValueFromPipelineByPropertyName=$true)]
        [Alias("FullName")]
        [ValidateNotNullOrEmpty()]
        [SupportsWildcards()]
        [string[]]
        $Path,


        # Gets events from the event logs on the specified computer. Type the NetBIOS name, an Internet Protocol (IP) address, or the fully qualified domain name of the computer.
        # The default value is the local computer.
        # To get events and event logs from remote computers, the firewall port for the event log service must be configured to allow remote access.
        [Parameter(Mandatory = $true,
                   ValueFromPipelineByPropertyName = $true,
                   ParameterSetName = 'Remote')]
        [string[]]
        $ComputerName,

        # Specifies a user account that has permission to perform this action.
        #
        # Type a user name, such as User01 or Domain01\User01. Or, enter a PSCredential object, such as one generated by the Get-Credential cmdlet. If you type a user name, you will
        # be prompted for a password. If you type only the parameter name, you will be prompted for both a user name and a password.
        [Parameter(Mandatory = $false,
                   ParameterSetName = 'Remote')]
        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute()]
        $Credential,

        # Specifies the maximum number of events that are returned. Enter an integer. The default is to return all the events in the logs or files.
        [Parameter(Mandatory = $false,
                   ValueFromPipelineByPropertyName = $true)]
        [int64]
        $MaxEvents,

        # Stsrttime from where to pull events.
        [Parameter(Mandatory = $false)]
        [datetime]
        $StartTime,

        # Stsrttime from where to pull events.
        [Parameter(Mandatory = $false)]
        [datetime]
        $EndTime,

        # Changes the default logic for matching fields from 'and' to 'or'.
        [Parameter(Mandatory = $false)]
        [switch]
        $ChangeLogic,

        # Changes the query action from inclusion to exclusion when fields are matched.
        [Parameter(Mandatory = $false)]
        [switch]
        $Suppress
    )

    begin {}

    process {
        Search-SysmonEvent -EventId 7 -ParamHash $MyInvocation.BoundParameters

    }

    end {}
}
