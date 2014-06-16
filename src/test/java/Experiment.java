import org.antlr.v4.runtime.ANTLRFileStream;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.misc.NotNull;
import org.antlr.v4.runtime.tree.ParseTreeWalker;

import java.io.IOException;

public class Experiment {

    public static void main(String... args) throws IOException {
        ANTLRFileStream input = new ANTLRFileStream("src/test/antlr4/use.cql");
        CQL3Lexer lexer = new CQL3Lexer(input);
        CommonTokenStream tokens = new CommonTokenStream(lexer);
        CQL3Parser parser = new CQL3Parser(tokens);

        CQL3Parser.StatementsContext statements = parser.statements();

        ParseTreeWalker walker = new ParseTreeWalker();
        walker.walk(new CQL3BaseListener() {
            @Override
            public void enterStatement(@NotNull CQL3Parser.StatementContext ctx) {
                System.out.println(ctx.toString());
            }
        }, statements);
    }
}
