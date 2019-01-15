# Les valeurs ci-dessous sont fournies à titre d'exemple
# Il est aussi possible de s'authentifier en exportant dans ses variables d'environnement OS_USERNAME, OS_PROJECT_ID, OS_PASSWORD, OS_REGION_NAME, OS_AUTH_URL
# Ou bien en exportant OS_CLOUD avec le nom du cloud que vous souhaitez utiliser,
# Ou encore en précisant dans 'cloud' le nom de cloud que vous souhaiter utiliser. 
provider "openstack" {
  user_name   = "TEST_USER_OCTAVIA"
  tenant_name = "TEST_OCTAVIA"
  password    = "test1234"
  auth_url    = "https://openstack.irt-systemx.fr:5000"
  region      = "RegionOne"
# Pour pouvoir utiliser octavia, le paramètre use_octavia est nécessaire
  use_octavia = true
}

resource "openstack_lb_loadbalancer_v2" "lb_1" {
  vip_subnet_id = "720d9a24-6151-4eee-8896-47130e30bee9"

  provisioner "local-exec" {
    command = "echo ${openstack_lb_loadbalancer_v2.lb_1.access_ip_v4} > ip_address.txt"
  }

}
resource "openstack_lb_listener_v2" "listener_1" {
  protocol        = "HTTP"
  protocol_port   = 80
  loadbalancer_id = "${openstack_lb_loadbalancer_v2.lb_1.id}"
}
resource "openstack_lb_pool_v2" "pool_1" {
  protocol    = "HTTP"
  lb_method   = "ROUND_ROBIN"
  listener_id = "${openstack_lb_listener_v2.listener_1.id}"
}
resource "openstack_lb_member_v2" "member_1" {
  address       = "192.168.208.108"
  protocol_port = 80
  pool_id       = "${openstack_lb_pool_v2.pool_1.id}"
}
resource "openstack_lb_member_v2" "member_2" {
  address       = "192.168.208.116"
  protocol_port = 80
  pool_id       = "${openstack_lb_pool_v2.pool_1.id}"
}

