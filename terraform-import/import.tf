import {
  to = vault_kv_secret_backend_v2.example
  id = "kvv2/config"
}

import {
  to = vault_kv_secret_v2.example
  id = "kvv2/data/secret"
}

import {
  to = vault_mount.kvv2
  id = "kvv2"
}
