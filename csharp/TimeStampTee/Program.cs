using System;
using System.IO;
using System.Text;

namespace TimeStampTee
{
    class Program
    {
        static void Usage()
        {
            Console.Error.WriteLine("usage: {0} [-a] [-t] filename",
                System.AppDomain.CurrentDomain.FriendlyName);
            Console.Error.WriteLine("-a: append logs to the end of file.");
            Console.Error.WriteLine("-t: append timestamps to the heads of each lines.");
        }

        static string AddTimeStamp(string line)
        {
            var dt = DateTime.Now;
            var ts = dt.ToString("yyyy/MM/dd HH:mm:ss.fff");

            return "[" + ts + "] " + line;
        }

        static int Main(string[] args)
        {
            string filename = null;
            bool isAddTimeStamp = false;
            bool isAppend = false;

            foreach (string arg in args)
            {
                if (arg.StartsWith("-"))
                {
                    if (string.Compare(arg, "-a") == 0)
                    {
                        isAppend = true;
                    }
                    else if (string.Compare(arg, "-t") == 0)
                    {
                        isAddTimeStamp = true;
                    }
                    else
                    {
                        Usage();
                        return 1;
                    }
                }
                else
                {
                    filename = arg;
                }
            }

            if (filename == null)
            {
                Usage();
                return 1;
            }

            var fileMode = isAppend ? FileMode.Append : FileMode.Create;
            var encoding = Encoding.Default;

            using (var fs = File.Open(filename, fileMode, FileAccess.Write, FileShare.Read))
            {
                using (var streamWriter = new StreamWriter(fs))
                {
                    while (true)
                    {
                        var line = Console.In.ReadLine();
                        if (line == null)
                        {
                            break;
                        }

                        var data = line;
                        if (isAddTimeStamp)
                        {
                            data = AddTimeStamp(line);
                        }

                        Console.WriteLine(data);
                        streamWriter.WriteLine(data);
                    }
                }
            }
            return 0;
        }
    }
}
