data "oci_objectstorage_namespace" "ns" {
  compartment_id = local.oci_compartment_id
}

resource "oci_objectstorage_bucket" "images" {
  compartment_id = local.oci_compartment_id
  name           = "kubernetes-oci-images"
  namespace      = data.oci_objectstorage_namespace.ns.namespace

  access_type  = "NoPublicAccess"
  auto_tiering = "Disabled"
  versioning   = "Enabled"
}

resource "oci_core_image" "talos-arm64" {
  compartment_id = local.oci_compartment_id

  display_name = "talos-arm64"
  launch_mode  = "PARAVIRTUALIZED"

  image_source_details {
    bucket_name    = oci_objectstorage_bucket.images.name
    namespace_name = oci_objectstorage_bucket.images.namespace
    object_name    = "oracle-arm64.oci"
    source_type    = "objectStorageTuple"
  }
}