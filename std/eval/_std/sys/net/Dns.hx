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

@:coreApi
final class Dns {
	public static function resolveSync(name:String):Array<IpAddress> {
		try {
			final ipv4 = resolveSyncIpv4Impl(name);
			return [@:privateAccess Ipv4Address.fromNetworkOrderInt(ipv4)];
		} catch (_) {
			return [];
		}
	}

	public static function reverseSync(address:IpAddress):Array<String> {
		return switch (address) {
			case V4(ipv4):
				[reverseSyncIpv4Impl(@:privateAccess ipv4.asNetworkOrderInt())];
			case _:
				throw new UnsupportedFamilyException("Eval cannot reverse lookup IPv6 addresses");
		}
	}

	public static function getLocalHostname():String {
		return getLocalHostnameImpl();
	}

	private static extern function resolveSyncIpv4Impl(name:String):Int;

	private static extern function reverseSyncIpv4Impl(ip:Int):String;

	private static extern function getLocalHostnameImpl():String;
}
