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

import haxe.Exception;
import java.net.Inet4Address;
import java.net.Inet6Address;
import java.net.InetAddress;

using Lambda;

@:coreApi
final class Dns {
	public static function resolveSync(name:String):Array<IpAddress> {
		@:nullSafety(Off) var nativeAddrs:Array<InetAddress> = null;

		try {
			nativeAddrs = @:privateAccess Array.ofNative(InetAddress.getAllByName(name));
		} catch (_) {
			return [];
		}

		final addresses:Array<IpAddress> = nativeAddrs.map(a -> {
			final inet4 = Std.downcast(a, Inet4Address);
			if (inet4 != null) {
				final ipv4 = Ipv4Address.tryParse(inet4.getHostAddress());
				if (ipv4 == null) {
					throw new Exception("Cannot get a valid IPv4 address from native object");
				}
				return ipv4;
			}

			final inet6 = Std.downcast(a, Inet6Address);
			if (inet6 != null) {
				final ipv6 = Ipv6Address.tryParse(inet6.getHostAddress());
				if (ipv6 == null) {
					throw new Exception("Cannot get a valid IPv6 address from native object");
				}
				return ipv6;
			}

			throw new Exception("Expected Inet4/6Address, got a different object");
		});

		return addresses;
	}

	public static function reverseSync(address:IpAddress):Array<String> {
		final nativeAddr = InetAddress.getByName(address.toString());
		return [nativeAddr.getHostName()];
	}

	public static function getLocalHostname():String {
		return InetAddress.getLocalHost().getHostName();
	}
}
