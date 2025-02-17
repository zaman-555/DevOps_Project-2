BLUE_NAMESPACE = blue-ns
GRAY_NAMESPACE = gray-ns
LIME_NAMESPACE = lime-ns

VETH_BLUE_PEER_NS = veth-blue-ns
VETH_LIME_PEER_NS = veth-lemon-ns
VETH_GRAY_PEER_NS = veth-gray-ns

VETH_BLUE_BR = veth-blue-br
VETH_LIME_BR = veth-lime-br
VETH_GRAY_BR = veth-gray-br

BRIDGE-V-NET = v-net

BRIDGE_V_NET_IP = 10.0.0.1
BLUE_NS_IP = 10.0.0.11
GRAY_NS_IP = 10.0.0.21
LIME_NS_IP = 10.0.0.31
DEFAULT_IP = 10.0.0.1
NETWORK_MASK = 24



# Create a Bridge v-net

bridge:
	 sudo ip link add dev v-net type bridge

# sudo ip links show

#----------------##---------------#

v-net-up:
	    sudo ip link set dev v-net up


# sudo ip links show

#----------------##---------------#

#----------------##---------------#

# Assign an IP address to the bridge interface 'v-net'

bridge_Ip:
		sudo ip address add $(BRIDGE_V_NET_IP)/$(NETWORK_MASK) dev $(BRIDGE-V-NET)

		

# sudo ip addr show dev v-net

#----------------##---------------#

#----------------##---------------#

# Create three network namespaces

create_ns:
		 sudo ip netns add $(BLUE_NAMESPACE)
		 sudo ip netns add $(GRAY_NAMESPACE)
		 sudo ip netns add $(LIME_NAMESPACE)
		 

# sudo ip netns list

#----------------##---------------#

#----------------##---------------#
# Create virtual Ethernet pairs


create_veth_pair:
		        sudo ip link add $(VETH_BLUE_PEER_NS) type veth peer name $(VETH_BLUE_BR)
                sudo ip link add $(VETH_LIME_PEER_NS) type veth peer name $(VETH_LIME_BR)
                sudo ip link add $(VETH_GRAY_PEER_NS) type veth peer name $(VETH_GRAY_BR)



#----------------##---------------#


#----------------##---------------#
# Move each end of veth cable to a different namespace


veth_connect:
            sudo ip link set dev $(VETH_BLUE_PEER_NS) netns $(BLUE_NAMESPACE)
			sudo ip link set dev $(VETH_LIME_PEER_NS) netns $(LIME_NAMESPACE)
			sudo ip link set dev $(VETH_GRAY_PEER_NS) netns $(GRAY_NAMESPACE)




# sudo ip netns exec <namespace-name> ip link show


#----------------##---------------#


#----------------##---------------#


# Add the other end of the virtual interfaces to the bridge


conect_v_net_bridge:
                   sudo ip link set dev $(VETH_BLUE_BR) master $(BRIDGE-V-NET)
				   sudo ip link set dev $(VETH_LIME_BR) master $(BRIDGE-V-NET)
				   sudo ip link set dev $(VETH_GRAY_BR) master $(BRIDGE-V-NET)




#----------------##---------------#

#----------------##---------------#

# Set the bridge interfaces up

bridge_int_up:
        sudo ip link set dev $(VETH_BLUE_BR) up
		sudo ip link set dev $(VETH_LIME_BR) up
		sudo ip link set dev $(VETH_GRAY_BR) up


# sudo ip link show (host)
         

#----------------##---------------#

#----------------##---------------#

# Set the namespace interfaces up

ns_int_up:
         ip netns exec $(BLUE_NAMESPACE) ip link set dev $(VETH_BLUE_PEER_NS) up
		 ip netns exec $(LIME_NAMESPACE) ip link set dev $(VETH_LIME_PEER_NS) up
		 ip netns exec $(GRAY_NAMESPACE) ip link set dev $(VETH_GRAY_PEER_NS) up
     
#----------------##---------------#

#----------------##---------------#


# Assign an IP address to the namesapce

blue_ns_assign_ip:
        sudo ip nets exec $(BLUE_NAMESPACE) ip address add $(BLUE_NS_IP)/$(NETWORK_MASK) dev $(VETH_BLUE_PEER_NS)
		sudo ip netns exec $(BLUE_NAMESPACE) ip route add default via $(DEFAULT_IP)

lime_ns_assign_ip:
		sudo ip nets exec $(LIME_NAMESPACE) ip address add $(LIME_NS_I)/$(NETWORK_MASK) dev $(VETH_LIME_PEER_NS)
		sudo ip netns exec $(LIME_NAMESPACE) ip route add default via $(DEFAULT_IP)

gray_ns_assign_ip:		
		sudo ip nets exec $(GRAY_NAMESPACE) ip address add $(GRAY_NS_IP)/$(NETWORK_MASK) dev $(VETH_GRAY_PEER_NS)
		sudo ip netns exec $(GRAY_NAMESPACE) ip route add default via $(DEFAULT_IP)


#----------------##---------------#

#----------------##---------------#