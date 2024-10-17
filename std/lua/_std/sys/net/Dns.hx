/*
 * Copyright (C)2005-2024 Haxe Foundation
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 */

package sys.net;

import lua.PairTools;
import lua.lib.luv.Os in LuvOs;
import lua.lib.luv.net.Dns in LuvDns;

@:coreApi
final class Dns {
	public static function resolveSync(name:String):Array<IpAddress> {
		final infos = LuvDns.getaddrinfo(name, null, null).result;
		if (infos == null) {
			return [];
		}

		final addresses:Array<IpAddress> = [];
		PairTools.ipairsEach(infos, (_, addrinfo) -> {
			switch (addrinfo.family) {
				case "inet":
					final ipv4 = Ipv4Address.tryParse(addrinfo.addr);
					if (ipv4 != null) {
						addresses.push(ipv4);
					}
				case "inet6":
					final ipv6 = Ipv6Address.tryParse(addrinfo.addr);
					if (ipv6 != null) {
						addresses.push(ipv6);
					}
				case _:
			}
		});
		return addresses;
	}

	public static function reverseSync(address:IpAddress):Array<String> {
		final reversed = LuvDns.getnameinfo({ip: address.toString()}).result;
		return reversed != null ? [reversed] : [];
	}

	public static function getLocalHostname():String {
		return LuvOs.gethostname();
	}
}
