
# liste les membre Disable
function Get-ADGroupMemberDisable()
{
    param($groupname, $domain)

    # recupere la liste des memebres
    $Group = Get-ADGroup -Filter "Name -eq '$groupname'" -Server $domain -Properties member

    # pour chaque memebre...
    foreach ( $user in $Group.member )
    {
        # si il n'est pas dans un autre domaine
        if ( $user -notlike "*ForeignSecurityPrincipals*" )
        {        
            # recupere le status enable
            $actif = $(Get-ADUser -Identity "$user" -Server $domain -Properties * -ErrorAction SilentlyContinue).Enabled

            # si enable a False alors affiche son nom
            if ( $actif -eq "False" )
            {
                Write-Output $user
            }
        }
    }

}

