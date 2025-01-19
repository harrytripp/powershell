# In this example the canonical name of the object would be: network.local/parent/child/grandchild
Get-ADUser -Filter * -SearchBase "OU=grandchild,OU=child,OU=parent,DC=network,DC=local"
