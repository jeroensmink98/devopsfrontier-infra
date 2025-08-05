data "azuread_user" "main" {
  user_principal_name = "info_devopsfrontier.com#EXT#@infodevopsfrontier.onmicrosoft.com"
}


resource "azuread_application" "main" {
  display_name     = "N8N Devopsfrontier"
  owners           = [data.azuread_user.main.object_id]
  sign_in_audience = "AzureADandPersonalMicrosoftAccount"

  api {
    requested_access_token_version = 2
  }

  web {
    redirect_uris = [
      "https://n8n.devopsfrontier.com/rest/oauth2-credential/callback"
    ]
  }

  required_resource_access {
    resource_app_id = "00000003-0000-0000-c000-000000000000" # Microsoft Graph

    # Basic OIDC permissions
    resource_access {
      id   = "37f7f235-527c-4136-accd-4a02d197296e" # openid
      type = "Scope"
    }

    resource_access {
      id   = "7427e0e9-2fba-42fe-b0c0-848c9e6a8182" # offline_access
      type = "Scope"
    }

    # User permissions
    resource_access {
      id   = "e1fe6dd8-ba31-4d61-89e7-88639da4683d" # User.Read
      type = "Scope"
    }

    resource_access {
      id   = "b4e74841-8e56-480b-be8b-910348b18b4c" # User.ReadWrite
      type = "Scope"
    }

    resource_access {
      id   = "a154be20-db9c-4678-8ab7-66f6cc099a59" # User.Read.All
      type = "Scope"
    }

    # Directory permissions
    resource_access {
      id   = "06da0dbc-49e2-44d2-8312-53f166ab848a" # Directory.Read.All
      type = "Scope"
    }

    resource_access {
      id   = "c5366453-9fb0-48a5-a156-24f0c49a4b84" # Directory.ReadWrite.All
      type = "Scope"
    }

    resource_access {
      id   = "0e263e50-5827-48a4-b97c-d940288653c7" # Directory.AccessAsUser.All
      type = "Scope"
    }

    # Group permissions
    resource_access {
      id   = "5f8c59db-677d-491f-a6b8-5f174b11ec1d" # Group.Read.All
      type = "Scope"
    }

    resource_access {
      id   = "4e46008b-f24c-477d-8fff-7bb4ec7aafe0" # GroupMember.ReadWrite.All
      type = "Scope"
    }

    # Sites permissions (SharePoint)
    resource_access {
      id   = "205e70e5-aba6-4c52-a976-6d2d46c48043" # Sites.Read.All
      type = "Scope"
    }

    resource_access {
      id   = "89fe6a52-be36-487e-b7d8-d061c450a026" # Sites.ReadWrite.All
      type = "Scope"
    }
  }
}

resource "azuread_application_password" "main" {
  application_id = azuread_application.main.id
  display_name   = "N8N Client Secret"
}
