using System;
using System.Text;

namespace Imax.Shared
{
    public static class Ean13Generator
    {
        private class NumberDescriptor
        {
            private static readonly char FirstDigitTableOffset;

            private static readonly char LTableOffset;

            private static readonly char GTableOffset;

            private static readonly char RTableOffset;

            private readonly string firstGroup;

            private readonly string secondGroup;

            static NumberDescriptor()
            {
                FirstDigitTableOffset = '0';
                LTableOffset = 'A';
                GTableOffset = 'K';
                RTableOffset = 'a';
            }

            public NumberDescriptor(string firstGroup, string secondGroup)
            {
                this.firstGroup = firstGroup;
                this.secondGroup = secondGroup;
            }

            public char GetOffsetForIndex(int index)
            {
                if (index == 0)
                {
                    return FirstDigitTableOffset;
                }

                if (index > 0 && index < 7)
                {
                    return firstGroup[index - 1] == 'L' ? LTableOffset : GTableOffset;
                }

                if (index > 6 && index < 13)
                {
                    if (secondGroup[index - 7] == 'R')
                        return RTableOffset;
                }

                throw new ArgumentOutOfRangeException();
            }
        }

        private static readonly char Marker;

        private static readonly NumberDescriptor[] Table;

        static Ean13Generator()
        {
            Marker = '*';
            Table = new[]
            {
                new NumberDescriptor("LLLLLL", "RRRRRR"),
                new NumberDescriptor("LLGLGG", "RRRRRR"),
                new NumberDescriptor("LLGGLG", "RRRRRR"),
                new NumberDescriptor("LLGGGL", "RRRRRR"),
                new NumberDescriptor("LGLLGG", "RRRRRR"),
                new NumberDescriptor("LGGLLG", "RRRRRR"),
                new NumberDescriptor("LGGGLL", "RRRRRR"),
                new NumberDescriptor("LGLGLG", "RRRRRR"),
                new NumberDescriptor("LGLGGL", "RRRRRR"),
                new NumberDescriptor("LGGLGL", "RRRRRR"),
            };
        }

        public static string GenerateBarCode(string number)
        {
            if (number.Length != 12)
            {
                return null;
            }

            int[] digits = new int[13];
            for (int i = 0; i < 12; i++)
            {
                if (!int.TryParse(number.Substring(i, 1), out digits[i]))
                {
                    return null;
                }
            }

            digits[12] = GetLastNumber(digits);

            var descriptor = Table[digits[0]];
            var resultBuilder = new StringBuilder();

            for (int i = 0; i < 7; i++)
            {
                resultBuilder.Append((char)(descriptor.GetOffsetForIndex(i) + digits[i]));
            }

            resultBuilder.Append(Marker);

            for (int i = 7; i < 13; i++)
            {
                resultBuilder.Append((char)(descriptor.GetOffsetForIndex(i) + digits[i]));
            }

            resultBuilder.Append(Marker);

            return resultBuilder.ToString();
        }

        private static int GetLastNumber(int[] digits)
        {
            var weights = new[] {1, 3, 1, 3, 1, 3, 1, 3, 1, 3, 1, 3};
            int sum = 0;
            for (int i = 0; i < 12; i++)
            {
                sum += digits[i]*weights[i];
            }

            var remainder = sum%10;
            return 10 - remainder;
        }
    }
}