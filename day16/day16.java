package day16;

import java.io.File;
import java.util.ArrayList;
import java.util.Scanner;

class Day16 {
    public static void main(String[] args) throws Exception {
        File file = new File("day16/input.txt");
        Scanner scanner = new Scanner(file);
        String line = new String();
        while (scanner.hasNextLine()) {
            line = scanner.nextLine();
        }
        String input = new String();
        for (char letter : line.toCharArray()) {
            switch (letter) {
                case '0':
                    input += "0000";
                    break;
                case '1':
                    input += "0001";
                    break;
                case '2':
                    input += "0010";
                    break;
                case '3':
                    input += "0011";
                    break;
                case '4':
                    input += "0100";
                    break;
                case '5':
                    input += "0101";
                    break;
                case '6':
                    input += "0110";
                    break;
                case '7':
                    input += "0111";
                    break;
                case '8':
                    input += "1000";
                    break;
                case '9':
                    input += "1001";
                    break;
                case 'A':
                    input += "1010";
                    break;
                case 'B':
                    input += "1011";
                    break;
                case 'C':
                    input += "1100";
                    break;
                case 'D':
                    input += "1101";
                    break;
                case 'E':
                    input += "1110";
                    break;
                case 'F':
                    input += "1111";
                    break;
            }
        }
        System.out.println(String.format("part 1: %d", 
            parse(input).packet.part1()));
        System.out.println(String.format("part 2: %d", 
            parse(input).packet.part2()));
    }

    static ParserResult parseLiteral(int version, String input) {
        Literal literal = new Literal();
        int index = 0;
        String literalString = new String();
        while (input.charAt(index) == '1') {
            literalString += input.substring(index + 1, index + 5);
            index += 5;
        }
        literalString += input.substring(index + 1, index + 5);
        index += 5;

        literal.literal = Long.parseUnsignedLong(literalString, 2);
        literal.type = 4;
        literal.version = version;
        ParserResult result = new ParserResult(literal, input.substring(index));
        return result;
    }

    static ParserResult parseOperator(int version, int type, String input) {
        Operator operator = new Operator();
        ParserResult finalResult = new ParserResult(operator, "fail");
        operator.type = type;
        operator.version = version;
        char lengthTypeID = input.charAt(0);
        int index = 1;
        if (lengthTypeID == '0') {
            // next 15 bits are a number that represents the total length
            // in bits
            String length = input.substring(index, index + 15);
            int bits = Integer.parseUnsignedInt(length, 2);
            index += 15;
            String packetContent = input.substring(index, index + bits);
            index += bits;
            while (true) {
                try {
                    ParserResult result = parse(packetContent);
                    operator.contents.add(result.packet);
                    packetContent = result.restInput;
                } catch (StringIndexOutOfBoundsException e) {
                    break;
                }
            }
            finalResult.restInput = input.substring(index);
        } else {
            // next 11 bits are a number that represents the number
            // of sub-packets immediately contained
            String length = input.substring(index, index + 11);
            int count = Integer.parseUnsignedInt(length, 2);
            index += 11;
            input = input.substring(index);
            for (int parsedPackets = 0; parsedPackets < count; parsedPackets++) 
            {
                ParserResult result = parse(input);
                operator.contents.add(result.packet);
                input = result.restInput;
            }
            finalResult.restInput = input;
        }
        // System.out.println(finalResult);
        return finalResult;
    }

    static ParserResult parse(String input) {
        int version = Integer.parseUnsignedInt(input.substring(0, 0 + 3), 2);
        int type = Integer.parseUnsignedInt(input.substring(3, 3 + 3), 2);
        if (type == 4) {
            return parseLiteral(version, input.substring(6));
        } else {
            return parseOperator(version, type, input.substring(6));
        }
    }
}

abstract class Packet {
    int version;
    int type;

    abstract int part1();

    abstract long part2();
}

class Literal extends Packet {
    long literal;

    @Override
    public String toString() {
        return String.format("Literal (v.%d) %d", version, literal);
    }

    int part1() {
        return version;
    }

    long part2() {
        return literal;
    }
}

class Operator extends Packet {
    ArrayList<Packet> contents;

    Operator() {
        contents = new ArrayList<>();
    }

    @Override
    public String toString() {
        return String.format("Operator (v%d;t%d) %s", version, type, contents);
    }

    @Override
    int part1() {
        int sum = version;
        for (Packet i : contents)
            sum += i.part1();
        return sum;
    }

    long part2() {
        switch (type) {
            case 0: {
                long sum = 0;
                for (Packet p : contents)
                    sum += p.part2();
                return sum;
            }
            case 1: {
                long prod = 1;
                for (Packet p : contents)
                    prod *= p.part2();
                return prod;
            }
            case 2: {
                long min = contents.get(0).part2();
                for (int i = 1; i < contents.size(); i++)
                    min = Long.min(contents.get(i).part2(), min);
                return min;
            }
            case 3: {
                long max = contents.get(0).part2();
                for (int i = 1; i < contents.size(); i++)
                    max = Long.max(contents.get(i).part2(), max);
                return max;
            }
            case 5: {
                long a = contents.get(0).part2();
                long b = contents.get(1).part2();
                if (a > b)
                    return 1;
                else
                    return 0;
            }
            case 6: {
                long a = contents.get(0).part2();
                long b = contents.get(1).part2();
                if (a < b)
                    return 1;
                else
                    return 0;
            }
            case 7: {
                long a = contents.get(0).part2();
                long b = contents.get(1).part2();
                if (a == b)
                    return 1;
                else
                    return 0;
            }
        }
        return -1;
    }
}

class ParserResult {
    Packet packet;
    String restInput;

    ParserResult(Packet packet, String rest) {
        restInput = rest;
        this.packet = packet;
    }

    @Override
    public String toString() {
        return String.format("ParserResult with Packet(%s) and rest(%s)", 
            packet, 
            restInput);
    }
}