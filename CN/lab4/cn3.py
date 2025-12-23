from scapy.all import *
from collections import Counter
pkts = rdpcap('ss.pcap')
print(f"--- Analysis Report for ss.pcap ---")
total_packets = len(pkts)
print(f"Total Number of packets: {total_packets}")
src_ips = set()
dst_ips = set()
protocols = []
for pkt in pkts: 
    if IP in pkt:
        src_ips.add(pkt[IP].src)
        dst_ips.add(pkt[IP].dst)
    proto_name = pkt.lastlayer().name
    protocols.append(proto_name)
num_src_ips = len(src_ips)
num_dst_ips = len(dst_ips)
proto_counts = Counter(protocols)
print(f"Number of unique Source IPs: {num_src_ips}")
print(f"Number of unique Destination IPs: {num_dst_ips}")
print(f"Number of unique protocols used: {len(proto_counts)}")
print("\n--- Packets under every protocol ---")
for proto, count in proto_counts.items():
    print(f"{proto}: {count}")
