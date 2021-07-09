$choice

DO

{
    '0-Salir'
    '1-Ver todos los usuarios'
    '2-Ver datos de un solo usuario'
    '3-Modificar atributo de usuario'
    '4-Eliminar un usuario'
    '5-Ver usuarios de un grupo'
    
    $choice = Read-Host 'Decisión'
    
    switch ( $choice )
    {
        #Recuperamos todos los usuarios del AD
        1 { Get-ADUser -Filter * -SearchBase "OU=Users_MB,OU=USUARIOS LRC,DC=mb,DC=lrcpre,DC=es" }

        2 {
                                   
            
                
                $Name = Read-Host -Prompt "¿De qué usuario quieres ver la información?"
                $User = Get-ADUser -Filter {sAMAccountName -eq $Name}
                If ($User -eq $Null) {"El usuario " + $Name + " no existe en el AD actual"}
                Else {
                #Mostramos las propiedades genéricas del usuario + las especificadas
                #Si estas últimas son null no se mostrará ni el título

                    "Usuario " + $Name + " encontrado: "                     
                    Get-ADUser -Identity ($User) -Properties Mail,telephoneNumber 
                    

                }
           
           
            
        }
         3{
            $Name = Read-Host -Prompt "¿Qué usuario quieres actualizar?"
            $User = Get-ADUser -Filter {sAMAccountName -eq $Name}
                If ($User -eq $Null) {"El usuario " + $Name + " no existe en el AD actual"}
                Else {
                #Mostramos las propiedades genéricas del usuario + las especificadas
                #Si estas últimas son null no se mostrará ni el título

                    "Usuario " + $Name + " encontrado: "                     
                    Get-ADUser -Identity ($User) -Properties Mail,telephoneNumber 

                    '¿Qué atributo se actualizará?'
                    'm=mail | t=teléfono | te=teléfono de empresa | tit=título'
                    $Decision = Read-Host -Prompt "Decisión"
                     switch ( $Decision )
                        {
                        t{
                        'El teléfono del usuario ' + $Name + ' es ' 
                         
                        Get-ADUser -Identity ($User) -Properties MobilePhone | Select-Object MobilePhone
                        $NuevoTlf = Read-Host -Prompt "Nuevo teléfono:"
                         Set-ADUser -Identity ($User) -MobilePhone $NuevoTlf                                                
                         'Teléfono actualizado'
                        }
                        m{
                         Get-ADUser -Identity ($User) -Properties Mail | Select-Object Mail
                         $NuevoMail = Read-Host -Prompt "¿Qué nuevo mail quieres asignar?"
                         Set-ADUser -Identity ($User) -Email ($NuevoMail)
                         'Mail actualizado'
                        }
                        }
                }
         }
        4 { 
        $NombreElim = Read-Host -Prompt "¿Qué usuario quieres eliminar?`r`n"
        $UserElim = Get-ADUser -Filter {sAMAccountName -eq $NombreElim}
                If ($UserElim -eq $Null) {"El usuario " + $NombreElim + " no existe en el AD actual"}
                Else {
          
                    #Pedimos confirmación y eliminamos el usuario

                    "Usuario " + $NombreElim + " encontrado: "                     
                    Get-ADUser -Identity ($UserElim) -Properties Mail,telephoneNumber 

                    '¿Estás seguro de querer eliminar al usuario' + $NombreElim + '?' 
                     $confirmacion = Read-Host '(s/n)'

                     if($confirmacion.Equals('s') -or ($confirmacion.Equals('S')))
                     {
                     #Necesario reiniciar/sincronizar el AD para que desaparezca el usuario
                     #El confirm false impide que salga un popup intrusivo en el AD pidiendo confirmación
                    Remove-ADUser -Identity $UserElim -Confirm:$false
                    
                    'Usuario eliminado satisfactoriamente'
                     }

                     else{
                     'No se eliminará el usuario ' + $NombreElim
                     }

                    
                }
        }
        5{
     
        Get-ADUser -Filter * -SearchBase "OU=Users_MB,OU=USUARIOS LRC,DC=mb,DC=lrcpre,DC=es"
        
       
        }
        
    }
    
} While ($choice -ne 0)



