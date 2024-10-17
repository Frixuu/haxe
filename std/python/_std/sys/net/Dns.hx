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

import haxe.extern.EitherType;
import python.Syntax;
import python.Tuple.*;

@:coreApi
final class Dns {
	public static function resolveSync(name:String):Array<IpAddress> {
		try {
			final addresses = [];
			for (addrinfo in PythonSocket.getaddrinfo(name, null, 0, 0, 0, 0)) {
				switch (addrinfo[0]) {
					case PythonSocket.AF_INET:
						final ipv4 = Ipv4Address.tryParse(addrinfo[3][0]);
						if (ipv4 != null && !Lambda.exists(addresses, a -> a.toString() == ipv4.toString())) {
							addresses.push(ipv4);
						}
					case PythonSocket.AF_INET6:
						final ipv6 = Ipv6Address.tryParse(addrinfo[3][0]);
						if (ipv6 != null && !Lambda.exists(addresses, a -> a.toString() == ipv6.toString())) {
							addresses.push(ipv6);
						}
					case _:
				}
			}
			return addresses;
		} catch (_) {
			return [];
		}
	}

	public static function reverseSync(address:IpAddress):Array<String> {
		final nameInfo = switch (address) {
			case V4(ipv4):
				PythonSocket.getnameinfo(Syntax.tuple(ipv4.toString(), 0), 0);
			case V6(ipv6):
				PythonSocket.getnameinfo(Syntax.tuple(ipv6.toString(), 0, 0, 0), 0);
		};

		final reversed = nameInfo[0];
		return if (reversed != address.toString()) {
			[reversed];
		} else {
			[];
		};
	}

	public static function getLocalHostname():String {
		return PythonSocket.gethostname();
	}
}

private typedef Inet4SockAddr = Tuple2<String, Int>;
private typedef Inet6SockAddr = Tuple4<String, Int, Int, Int>;
private typedef InetSockAddr = EitherType<Inet4SockAddr, Inet6SockAddr>;

@:pythonImport("socket")
private extern class PythonSocket {
	public static var AF_INET(default, never):Int;
	public static var AF_INET6(default, never):Int;
	public static function getaddrinfo(host:String, ?port:EitherType<Int, String>, family:Int = 0, type:Int = 0, proto:Int = 0,
		flags:Int = 0):Tuple5<Int, Int, Int, String, InetSockAddr>;
	public static function gethostname():String;
	public static function getnameinfo(sockaddr:InetSockAddr, flags:Int):Tuple2<String, String>;
}
