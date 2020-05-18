// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.
// See the LICENSE file in the project root for more information.

using System;

namespace Xunit
{
    [Flags]
    public enum TestPlatforms
    {
        Windows = 1,
        Linux = 2,
        OSX = 4,
        FreeBSD = 8,
        NetBSD = 16,
        SunOS = 32,
        iOS = 64,
        tvOS = 128,
        Android = 256,
        Browser = 512,
        AnyUnix = FreeBSD | Linux | NetBSD | OSX | SunOS | iOS | tvOS | Android | Browser,
        Any = ~0
    }
}
