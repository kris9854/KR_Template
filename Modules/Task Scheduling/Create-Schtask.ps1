# Helper for task sheduling 
function Create-SCHTask {
    [CmdletBinding()]
    param (
        # Task Name 
        [Parameter(Mandatory = $true)]
        [ParameterType]
        $TaskName
    )
    
    begin {
        # Check if there is another task named that 
        if ([bool](Get-ScheduledTask -TaskName "$TaskName")) {
            Throw("Error a task with that name allready exist")
        }
    }
    
    process {
        
    }
    
    end {
        
    }
}