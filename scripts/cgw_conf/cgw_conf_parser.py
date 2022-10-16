import xml.etree.ElementTree as ET

def cgw_conf_parser(cgw_conf):
    # cgw_conf = cgw_conf[6:-4] # delete EOT
    root = ET.fromstring(cgw_conf)
    vgw_ip = root[4][0][0][0].text
    print(vgw_ip)

if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser()
    parser.add_argument("--cgw_conf2", required=True, type=str)
    parsed_args = parser.parse_args()
    cgw_conf_parser(parsed_args.cgw_conf2)