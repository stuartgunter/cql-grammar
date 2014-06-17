import org.antlr.v4.runtime.ANTLRFileStream;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.misc.Interval;
import org.antlr.v4.runtime.misc.NotNull;
import org.antlr.v4.runtime.tree.ParseTreeWalker;

import java.io.IOException;

public class Experiment {

    public static void main(String... args) throws IOException {
        printStatements("src/test/antlr4/alter-keyspace.cql");
    }

    private static void printStatements(String fileName) throws IOException {
        final ANTLRFileStream input = new ANTLRFileStream(fileName);
        CQL3Lexer lexer = new CQL3Lexer(input);
        CommonTokenStream tokens = new CommonTokenStream(lexer);
        CQL3Parser parser = new CQL3Parser(tokens);

        CQL3Parser.StatementsContext statements = parser.statements();

        ParseTreeWalker walker = new ParseTreeWalker();
        walker.walk(new CQL3BaseListener() {
            @Override
            public void enterStatement(@NotNull CQL3Parser.StatementContext ctx) {
                CQL3Parser.Use_stmtContext use = ctx.use_stmt();

                int a = use.start.getStartIndex();
                int b = use.stop.getStopIndex();
                Interval interval = new Interval(a,b);
                System.out.println(input.getText(interval));
            }
        }, statements);
    }
}
